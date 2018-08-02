defmodule BackendPhoenix.Accounts.Users do
  import Tokenizer
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.Schema.User

  def list do
    User
    |> Repo.all()
  end

  def create(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get!(id) do
    Repo.get(User, id)
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_by_token(nil) do
    {:error, "missing token"}
  end

  def get_by_token(token) do
    case decode(token) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end
end
