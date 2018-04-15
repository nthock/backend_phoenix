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
    |> insert_user
  end

  defp insert_user(%{valid?: false} = changeset) do
    changeset
  end

  defp insert_user(%{valid?: true} = changeset) do
    changeset
    |> Repo.insert!
  end
end
