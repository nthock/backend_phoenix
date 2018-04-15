defmodule GraphQL.Resolver.User do
  import Tokenizer
  alias BackendPhoenix.Accounts

  def list(_parent, _input, _context) do
    {:ok, Accounts.list_users}
  end

  def create(_parent, %{input: attributes}, _info) do
    user =
      Accounts.create_user(attributes)
      |> parse_user

    {:ok, user}
  end

  defp parse_user(%{valid?: false, errors: errors}) do
    {error_key, {reason, _}} = List.first(errors)
    %{errors: %{key: error_key, value: reason}}
  end

  defp parse_user(user) do
    user
    |> issue_token
  end

  defp issue_token(user) do
    token =
      encode(%{
        id: user.id,
        name: user.name
      })

    Map.put(user, :token, token)
  end
end
