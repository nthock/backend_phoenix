defmodule BackendPhoenix.Accounts.Admins do
  import Ecto.Query
  alias BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.Schema.User

  def list do
    from(u in User, where: u.admin == true or u.super_admin == true)
    |> Repo.all()
  end

  def create(attrs \\ %{}) do
    %User{}
    |> User.admin_changeset(attrs)
    |> Repo.insert()
  end

  def get(id) do
    Repo.get(User, id)
    |> parse()
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
    |> parse()
  end

  defp parse(%{admin: true} = user) do
    {:ok, user}
  end

  defp parse(_user) do
    {:error, "not an admin"}
  end
end
