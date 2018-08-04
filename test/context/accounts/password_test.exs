defmodule BackendPhoenix.Context.Accounts.PasswordTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts.Password
  import BackendPhoenix.Factory

  setup do
    user = insert(:user, email: "user1@example.com")
    {:ok, %{user: user}}
  end

  describe "forget/1" do
    test "should be able to generate a reset password token", %{user: user} do
      {:ok, updated_user} = Password.forget(user.email)
      refute is_nil(updated_user.reset_password_token)
      refute is_nil(updated_user.reset_password_sent_at)
    end

    test "should return error if the user is not found" do
      assert {:error, _} = Password.forget("not_valid_email@example.com")
    end
  end

  describe "reset/1" do
    setup %{user: user} do
      {:ok, updated_user} = Password.forget(user.email)
      {:ok, %{updated_user: updated_user}}
    end

    test "should be able to change the password and clear the token", %{updated_user: updated_user} do
      attrs = %{
        reset_password_token: updated_user.reset_password_token,
        password: "password",
        password_confirmation: "password"
      }

      {:ok, reset_user} = Password.reset(attrs)
      assert is_nil(reset_user.reset_password_token)
      assert is_nil(reset_user.reset_password_sent_at)
    end

    test "should return error if the user password reset_token_is_not_found" do
      attrs = %{
        reset_password_token: "not a valid_token",
        password: "password",
        password_confirmation: "password"
      }

      assert {:error, _} = Password.reset(attrs)
    end
  end
end