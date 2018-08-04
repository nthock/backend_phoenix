defmodule BackendPhoenix.Accounts.Password do
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.Users
  alias BackendPhoenix.Accounts.Schema.User

  def forget(email) do
    email
    |> Users.get_by_email()
    |> User.forget_password_changeset()
    |> Repo.update()
  end

  def reset(attrs) do
    attrs
    |> Map.get(:reset_password_token)
    |> Users.get_by_reset_password_token()
    |> User.reset_password_changeset(attrs)
    |> Repo.update()
  end
end