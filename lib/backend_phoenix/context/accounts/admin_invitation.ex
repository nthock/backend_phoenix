defmodule BackendPhoenix.Accounts.AdminInvitation do
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.Schema.User

  def create(attrs \\ %{}, inviter_id) do
    %User{}
    |> User.admin_invitation_changeset(attrs, inviter_id)
    |> Repo.insert()
  end
end