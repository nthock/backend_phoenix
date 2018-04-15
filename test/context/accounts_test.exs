defmodule BackendPhoenix.Context.AccountsTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts

  test "should be able to create user with the correct attributes" do
    attrs = %{
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
    user = Accounts.create_user(attrs)
    assert %{name: "Test User", email: "test@example.com"} = user
  end

  test "should return the error changeset when creating user with incorrect attributes" do
    attrs = %{
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password1234"
    }
    %{errors: errors} = Accounts.create_user(attrs)
    assert {:password_confirmation, {error_message, _}} = List.first(errors)
    assert error_message == "does not match"
  end
end
