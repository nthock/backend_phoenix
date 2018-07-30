defmodule BackendPhoenix.Context.Accounts.AdminsTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts.Admins
  import BackendPhoenix.Factory
  # import Map.Helpers

  setup do
    admin = insert(:admin, email: "admin1@example.com")
    insert(:admin, email: "admin2@example.com")
    user = insert(:user, email: "user2@example.com")

    {:ok, %{admin: admin, user: user}}
  end

  describe "list/0" do
    test "should be able to get all admins" do
      admins = Admins.list()
      assert Enum.count(admins) == 2
    end
  end

  describe "create/1" do
    test "should be able to create admin with correct attributes" do
      attrs = params_for(:admin, email: "new_admin@example.com", name: "New Admin")
      {:ok, new_admin} = Admins.create(attrs)
      assert %{name: "New Admin", email: "new_admin@example.com", admin: true} = new_admin
    end

    test "should return the error changeset when creating user with incorrect attributes" do
      attrs = %{
        name: "Test User",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password1234"
      }

      assert {:error, changeset} = Admins.create(attrs)
      assert {:password_confirmation, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "does not match"
    end
  end

  describe "get/1" do
    test "should be able to retrieve an admin given its id", %{admin: admin} do
      assert {:ok, admin_result} = Admins.get(admin.id)
      assert admin_result.id == admin.id
    end

    test "should return error if the user for the given id is not an admin", %{user: user} do
      assert {:error, _error} = Admins.get(user.id)
    end
  end

  describe "get_by_email/1" do
    test "should be able to retrieve an admin given its email", %{admin: admin} do
      assert {:ok, admin_result} = Admins.get_by_email(admin.email)
      assert admin_result.id == admin.id
    end

    test "should return error if the user for the given email is not an admin", %{user: user} do
      assert {:error, _error} = Admins.get_by_email(user.email)
    end
  end
end
