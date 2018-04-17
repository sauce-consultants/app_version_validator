defmodule AppVersionValidatorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias AppVersionValidator, as: Validator


  test "if no version specified then return error" do

    verification_result = Validator.verify(nil)

    assert verification_result == :error

  end

  test "if no version specified and nil_version_allowed is true return ok" do
    env = [
        nil_version_allowed: true
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify(nil)

    assert verification_result == :ok

  end

  test "if version specified is less than required in config then return error" do
    env = [
        minimum_app_version: "0.2.5"
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify("0.1.2")

    assert verification_result == :error

  end

  test "if version specific is equal to the required in config then return ok" do
    env = [
        minimum_app_version: "0.2.9"
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify("0.2.9")

    assert verification_result == :ok
  end

  test "if version specific is greater than the required in config then return ok" do
    env = [
        minimum_app_version: "0.4.6"
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify("0.6.0")

    assert verification_result == :ok
  end

  test "handle if the app version length is shorter than the config value" do
    env = [
        minimum_app_version: "0.4.6"
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify("1")

    assert verification_result == :ok
  end

  test "handle if the app version length is longer than the config value" do
    env = [
        minimum_app_version: "0.4"
    ]

    Application.put_env(:app_version_validator, AppVersionValidator, env)

    verification_result = Validator.verify("1.4.2.2")

    assert verification_result == :ok
  end
end
