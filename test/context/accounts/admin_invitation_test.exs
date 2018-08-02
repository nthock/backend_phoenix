defmodule BackendPhoenix.Context.Accounts.AdminInvitationTest do
  use BackendPhoenix.ConnCase, async: true
  alias BackendPhoenix.Accounts.AdminInvitation
  import BackendPhoenix.Factory

  @valid_attrs %{email: "new_admin@example.com", name: "New Admin"}

  setup do
    super_admin = insert(:super_admin, email: "admin1@example.com")
    admin = insert(:admin, email: "just_an_admin@example.com")
    user = insert(:user)

    {:ok, %{super_admin: super_admin, admin: admin, user: user}}
  end

  describe "create/2" do
    test "super_admin should be able to create an invited admin with valid attrs", %{super_admin: super_admin} do
      assert {:ok, user} = AdminInvitation.create(@valid_attrs, super_admin.id)
      assert user.name == @valid_attrs.name
      assert user.email == @valid_attrs.email
      assert user.invited_by_id == super_admin.id
      refute is_nil(user.invitation_token)
      refute is_nil(user.invitation_created_at)
    end

    test "super_admin should not be able to create an invited admin with invalid_attrs", %{super_admin: super_admin} do
      attrs = %{name: "New Admin"}
      assert {:error, changeset} = AdminInvitation.create(attrs, super_admin.id)
      assert {:email, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "can't be blank"
    end

    test "admin should not be able to create an invited admin with valid attrs", %{admin: admin} do
      assert {:error, changeset} = AdminInvitation.create(@valid_attrs, admin.id)
      assert {:invited_by_id, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "Must be a super_admin"
    end

    test "normal user should not be able to create an invited admin with valid attrs", %{user: user} do
      assert {:error, changeset} = AdminInvitation.create(@valid_attrs, user.id)
      assert {:invited_by_id, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "Must be a super_admin"
    end
  end

  describe "accept/2" do
    setup %{super_admin: super_admin} do
      {:ok, user} = AdminInvitation.create(@valid_attrs, super_admin.id)
      {:ok, %{user: user}}
    end

    test "should be able to accept invitation with the correct attributes", %{user: user} do
      attrs = %{
        invitation_token: user.invitation_token,
        password: "password",
        password_confirmation: "password"
      }

      assert {:ok, user} = AdminInvitation.accept(attrs)
      assert user.invitation_accepted
      assert is_nil(user.invitation_token)
      refute is_nil(user.invitation_accepted_at)
    end

    test "should return error if accepting invitation with incorrect attributes", %{user: user} do
      attrs = %{
        invitation_token: user.invitation_token,
        password: "password",
        password_confirmation: "another_password"
      }

      assert {:error, changeset} = AdminInvitation.accept(attrs)
      assert {:password_confirmation, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "does not match"
    end

    test "should return error if the invitation token is not valid" do
      attrs = %{
        invitation_token: "not_a_valid_token",
        password: "password",
        password_confirmation: "password"
      }

      assert {:error, changeset} = AdminInvitation.accept(attrs)
      assert {:id, {error_message, _}} = List.first(changeset.errors)
      assert error_message == "not a valid user"
    end
  end
end