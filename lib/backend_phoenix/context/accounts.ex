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
    |> IO.inspect(label: "User registration changeset")
    |> Repo.insert
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
