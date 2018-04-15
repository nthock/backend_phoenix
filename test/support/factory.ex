defmodule BackendPhoenix.Factory do
  use ExMachina.Ecto, repo: BackendPhoenix.Repo
  alias BackendPhoenix.Accounts.User

  def user_factory do
    %User{
      name: "Jimmy",
      email: "jimmy@example.com",
      designation: "Founder",
      password: "password",
      super_admin: true,
      admin: true
    }
  end
end
