defmodule AppVersionValidator do
  @moduledoc """
  Module to validate that the app version passed in meets the minimum requirements
  """

  def verify(version_number) when is_nil(version_number) do
    is_nil_allowed? = Application.get_env(:app_version_validator, AppVersionValidator)[:nil_version_allowed]

    if is_nil_allowed? do
      :ok
    else
      :error
    end
  end
  def verify(version_number) do
    split_version_numbers =
      version_number
      |> String.split(".")
      |> convert_strings_to_numbers()

    split_minimum_version_numbers =
      Application.get_env(:app_version_validator, AppVersionValidator)[:minimum_app_version]
      |> String.split(".")
      |> convert_strings_to_numbers()

    {version_numbers, minimum_version_numbers} =
      correct_version_number_lengths(split_version_numbers, split_minimum_version_numbers)

    version_numbers
    |> is_version_number_above_minimum_version_required?(minimum_version_numbers)
    |> case do
      :equal -> :ok
      :gt -> :ok
      :lt -> :error
    end
  end

  def is_version_number_above_minimum_version_required?(version_numbers, minimum_version_numbers) do
    version_numbers
    |> Enum.with_index()
    |> Enum.reduce(nil, fn({number, position}, checking_state_ok) ->
      checking_version_number = Enum.at(minimum_version_numbers, position)
      cond do
        checking_state_ok == :lt -> :lt
        checking_state_ok == :gt -> :gt
        number > checking_version_number -> :gt
        number == checking_version_number -> :equal
        number < checking_version_number -> :lt
      end
    end)
  end


  def does_checking_map_contain_only_true_values?(checking_map) do
    number_of_false_values =
      checking_map
      |> Enum.filter(fn(boolean_value) ->
        !boolean_value
      end)
      |> length()

    number_of_false_values > 0
  end

  defp correct_version_number_lengths(version_numbers, minimum_version_numbers) do
    if version_number_lengths_match?(version_numbers, minimum_version_numbers) do
      {version_numbers, minimum_version_numbers}
    else
      pad_appropriate_version_number_list(version_numbers, minimum_version_numbers)
    end
  end

  defp version_number_lengths_match?(version_numbers, minimum_version_numbers) do
    length(version_numbers) == length(minimum_version_numbers)
  end

  defp pad_appropriate_version_number_list(version_numbers, minimum_version_numbers) do
    version_numbers_length = length(version_numbers)
    minimum_version_numbers_length = length(minimum_version_numbers)

    if version_numbers_length > minimum_version_numbers_length do
      minimum_version_numbers =
        minimum_version_numbers
        |> pad_number_by(version_numbers_length)
    else
      version_numbers =
        version_numbers
        |> pad_number_by(minimum_version_numbers_length)
    end

    {version_numbers, minimum_version_numbers}
  end

  defp pad_number_by(version_number, required_length) do
    difference_in_length =
      required_length - length(version_number)

    1..difference_in_length
    |> Enum.reduce(version_number, fn(_version_number, padded_version_number) ->
      List.insert_at(padded_version_number, -1, 0)
    end)
  end

  defp convert_strings_to_numbers(values) do
    values
    |> Enum.map(fn(value) ->
      String.to_integer(value)
    end)
  end

end
