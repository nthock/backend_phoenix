defmodule BackendPhoenix.Context.AccountsTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts
  import BackendPhoenix.Factory
  import Map.Helpers

  setup do
    user = insert(:user, email: "user1@example.com")
    insert(:user, email: "user2@example.com")

    {:ok, %{user: user}}
  end

  test "should be able to get all users" do
    users = Accounts.list_users()
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
      |> Enum.each(fn invalid_email ->
        assert Accounts.get_user_by_email(invalid_email) == nil
      end)
    end
  end

  describe "Get user by token" do
    test "should be able to decode token if given a valid token", %{user: user} do
      user_params =
        user
        |> Map.take([:id, :name, :admin, :super_admin])

      token =
        user_params
        |> Tokenizer.encode()

      assert Accounts.get_user_by_token(token) == {:ok, stringify_keys(user_params)}
    end

    test "should return error when given an invalid token" do
      assert {:error, "Invalid signature"} = Accounts.get_user_by_token("invalid_token")
    end

    test "should return error with missing token when not given token" do
      assert {:error, "missing token"} = Accounts.get_user_by_token(nil)
    end
  end
end
