defmodule BackendPhoenix.GraphQL.UserResolverTest do
  use BackendPhoenix.ConnCase, async: true
  import BackendPhoenix.Factory

  setup do
    insert(:user)
    :ok
  end

  @getUsersQuery """
  query getUsers {
    getUsers {
      id
      name
      email
      admin
      super_admin
    }
    }
  """

  @createUserMutation """
  mutation createUser($name: String, $email: String, $password: String, $password_confirmation: String) {
    createUser(input: { name: $name, email: $email, password: $password, password_confirmation: $password_confirmation }) {
      id
      name
      email
      designation
      status
      admin
      super_admin
      token
      errors {
        key
        value
      }
    }
  }
  """

  test "get all users" do
    response =
      build_conn()
      |> get("/graphql", query: @getUsersQuery)

    assert %{"data" => %{"getUsers" => results}} = json_response(response, 200)
    assert length(results) == 1

    assert [%{"name" => "Jimmy"}] = results
  end

  test "create user with valid attributes" do
    variables = %{
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }

    response =
      build_conn()
      |> post("/graphql", query: @createUserMutation, variables: variables)

    # IO.inspect(json_response(response, 200))
    assert %{"data" => %{"createUser" => result}} = json_response(response, 200)
    assert %{"name" => "Test User", "email" => "test@example.com"} = result
    assert %{"errors" => []} = result
  end

  test "create user with unmatched password" do
    variables = %{
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password1234"
    }

    response =
      build_conn()
      |> post("/graphql", query: @createUserMutation, variables: variables)

    assert %{"data" => %{"createUser" => result}} = json_response(response, 200)
    {:ok, errors} = result |> Map.fetch("errors")
    assert Enum.count(errors) == 1
    assert %{"key" => "password_confirmation", "value" => "does not match"} = List.first(errors)
  end
end
