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
end