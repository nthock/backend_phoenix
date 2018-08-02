defmodule BackendPhoenix.Accounts.AdminInvitation do
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.Users
  alias BackendPhoenix.Accounts.Schema.User

  def create(attrs \\ %{}, inviter_id) do
    %User{}
    |> User.admin_invitation_changeset(attrs, inviter_id)
    |> Repo.insert()
  end

  def accept(%{invitation_token: invitation_token} = attrs) do
    invitation_token
    |> Users.get_by_invitation_token()
    |> User.admin_accept_invitation_changeset(attrs)
    |> Repo.update()
  end
end