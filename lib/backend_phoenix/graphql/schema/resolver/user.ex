defmodule GraphQL.Resolver.User do
  alias BackendPhoenix.Accounts

  def list(_parent, _input, _context) do
    {:ok, Accounts.list_users}
  end
end
