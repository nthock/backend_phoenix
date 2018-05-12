defmodule GraphQL.Resolver.Auth do
  import Tokenizer
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias BackendPhoenix.Accounts
  alias BackendPhoenix.Accounts.User

  def create(_parent, %{input: %{email: email, password: password}}, _context) do
    Accounts.get_user_by_email(email)
    |> check_user_password(password)
  end

  require IEx
  defp check_user_password(%User{} = user, password) do
    password
    |> checkpw(user.encrypted_password)
    |> auth_result(user)
  end

  defp check_user_password(nil, _password) do
    dummy_checkpw()
    {:ok, invalid_password()}
  end

  defp auth_result(true, %User{} = user) do
    user = user |> issue_token
    {:ok, user}
  end

  defp auth_result(false, _user) do
    {:ok, invalid_password()}
  end

  defp invalid_password do
    dummy_checkpw()
    %{errors: %{key: "password", value: "is invalid"}}
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
