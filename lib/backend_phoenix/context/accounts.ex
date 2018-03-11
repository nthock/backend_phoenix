defmodule BackendPhoenix.Accounts do
  import Ecto.Query
  alias BackendPhoenix.Accounts.User

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert
  end
end
