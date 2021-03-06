defmodule Plug.AppVersionValidator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app_version_validator,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Basic App Version validation against an minimum requirement for an API.


    This should be useful if your API requires a minimum App version to be
    making the calls.
    If the App version is below the minimum requirement, the plug will return a
    http status of 418.
    """
  end

  defp package do
    [maintainers: ["John Polling"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/sauce-consultants/app_version_validator"}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:plug, "~> 1.3.3"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end

