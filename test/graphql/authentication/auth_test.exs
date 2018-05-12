defmodule BackendPhoenix.GraphQL.AuthResolverTest do
  use BackendPhoenix.ConnCase, async: true
  import BackendPhoenix.Factory

  setup do
    user_params = %{
      email: "jimmy@example.com",
      name: "Jimmy",
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("password"),
      admin: true,
      super_admin: false
    }
    user = insert(:user, user_params)
    {:ok, %{user: user, user_params: user_params}}
  end

  describe "user login" do
    @loginQuery """
    mutation authenticateUser($email: String, $password: String) {
      authenticate(input: { email: $email, password: $password }) {
        id
        email
        name
        token
        admin
        super_admin
        errors {
          key
          value
        }
      }
    }
    """

    test "login with valid credentials", %{user: user} do
      login_input = %{
        email: user.email,
        password: "password"
      }

      response = post(build_conn(), "/graphql", query: @loginQuery, variables: login_input)

      assert %{
        "data" => %{
          "authenticate" => %{
            "errors" => [],
            "email" => "jimmy@example.com",
            "id" => _id,
            "admin" => true,
            "token" => _token
          }
        }
      } = json_response(response, 200)
    end

    test "login with invalid credentials", %{user: user} do
      login_input = %{
        email: user.email,
        password: "password123"
      }

      response = post(build_conn(), "/graphql", query: @loginQuery, variables: login_input)

      assert %{
        "data" => %{
          "authenticate" => %{
            "errors" => [
              %{"key" => "password", "value" => "is invalid"}
            ],
          }
        }
      } = json_response(response, 200)
    end
  end

  describe "verify token" do
    @verifyTokenQuery """
    query verifyToken($token: String) {
      verifyToken(token: $token) {
        id
        name
        admin
        super_admin
        errors {
          key
          value
        }
      }
    }
    """

    test "verify valid token", %{user_params: user_params} do
      token =
        user_params
        |> Map.drop([:encrypted_password])
        |> Tokenizer.encode

      response = post(build_conn(), "/graphql", query: @verifyTokenQuery, variables: %{token: token})

      assert %{
        "data" => %{
          "verifyToken" => %{
            "admin" => true,
            "name" => "Jimmy",
            "super_admin" => false,
            "id" => _id
          }
        }
      } = json_response(response, 200)
    end

    test "verify invalid token" do
      token = "not_a_valid_token"
      response = post(build_conn(), "/graphql", query: @verifyTokenQuery, variables: %{token: token})

      assert %{"data" => %{"verifyToken" => %{"errors" => errors}}} = json_response(response, 200)
      assert %{"key" => "token", "value" => "Invalid signature"} = List.first(errors)
    end
  end
end
