defmodule GraphQL.Resolver.User do
  import Tokenizer
  alias BackendPhoenix.Accounts

  def list(_parent, _input, _context) do
    {:ok, Accounts.list_users}
  end

  def create(_parent, %{input: attributes}, _info) do
    with {:ok, user} <- Accounts.create_user(attributes) do
      user
      |> issue_token
    end
  end

  defp issue_token(user) do
    token =
      encode(%{
        id: user.id,
        name: user.name
      })

    {:ok, Map.put(user, :token, token)}
  end
end
