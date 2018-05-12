defmodule BackendPhoenix.Context.AccountsTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts
  import BackendPhoenix.Factory

  setup do
    insert(:user, email: "user1@example.com")
    insert(:user, email: "user2@example.com")

    :ok
  end

  test "should be able to get all users" do
    users = Accounts.list_users
    assert Enum.count(users) == 2
  end

  describe "Create User" do
    test "should be able to create user with the correct attributes" do
      attrs = %{
        name: "Test User",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
      {:ok, user} = Accounts.create_user(attrs)
      assert %{name: "Test User", email: "test@example.com"} = user
    end

    test "should return the error changeset when creating user with incorrect attributes" do
      attrs = %{
        name: "Test User",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password1234"
      }
      assert {:error, changeset} = Accounts.create_user(attrs)
      assert {:password_confirmation, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "does not match"
    end
  end

  describe "Get user by email" do
    test "should be able to get the correct user when given a valid email" do
      user = Accounts.get_user_by_email("user1@example.com")
      assert %{email: "user1@example.com"} = user
    end

    test "should return nil when given an invalid email or email not found in the system" do
      ["invalid_email", "user3@notvalid.com"]
      |> Enum.each(fn(invalid_email) ->
        assert Accounts.get_user_by_email(invalid_email) == nil
      end)
    end
  end
end
