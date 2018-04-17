defmodule AppVersionValidator.Plug.EnsureAppVersion do
  @moduledoc """
  Plug Module to validate that the app version passed in meets the minimum requirements
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> find_app_version()
    |> AppVersionValidator.verify()
    |> handle_response(conn)
  end

  defp find_app_version(conn) do
    conn.req_headers
    |> Enum.find(nil, fn({header, _value}) ->
      header == "app_version"
    end)
    |> case do
      nil -> nil
      {_header, version_number} -> version_number
    end
  end

  defp handle_response(:error, conn) do
    minimum_app_version =
      Application.get_env(:app_version_validator, AppVersionValidator)[:minimum_app_version]

    conn
    |> halt()
    |> put_resp_content_type("text/plain")
    |> send_resp(418, "The app version it below the minumum required: #{minimum_app_version}")
  end
  defp handle_response(:ok, conn), do: conn
end
