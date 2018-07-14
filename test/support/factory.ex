defmodule BackendPhoenix.Factory do
  use ExMachina.Ecto, repo: BackendPhoenix.Repo
  use BackendPhoenix.UserFactory
end
