# AppVersionValidator

Simple Plug to validate the app version that is sent in an API header to make
sure that the API should respond as normal, or just return an error.

The error we are using is [418 I'm a Teapot](https://httpstatuses.com/418)

The API calls should contain a header of `app_version`
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `app_version_validator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:app_version_validator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/app_version_validator](https://hexdocs.pm/app_version_validator).

## Configuration
```
config :app_version_validator, AppVersionValidator,
  minimum_app_version: "1.0.0",
  nil_version_allowed: true #optional
```



