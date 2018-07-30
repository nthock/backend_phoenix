defmodule GraphQL.Resolver.User do
  import Tokenizer
  alias BackendPhoenix.Accounts.Users

  def list(_parent, _input, _context) do
    {:ok, Users.list()}
  end

  def create(_parent, %{input: attributes}, _info) do
    with {:ok, user} <- Users.create(attributes) do
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
