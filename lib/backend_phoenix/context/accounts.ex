defmodule BackendPhoenix.Accounts do
  import Ecto.Query
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.User

  def list_users do
    User
    |> Repo.all
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert
  end
end
