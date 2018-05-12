defmodule GraphQL.Schema do
  use Absinthe.Schema
  alias GraphQL.Resolver
  alias GraphQL.Schema.Middleware
  import_types(GraphQL.Schema.Types)

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    field :get_users, type: list_of(:user) do
      resolve(&Resolver.User.list/3)
    end

    field :verify_token, type: :user do
      arg :token, non_null(:string)
      resolve(&Resolver.Auth.verify_token/3)
    end
  end

  mutation do
    field :create_user, type: :user do
      arg :input, non_null(:user_input)
      resolve(&Resolver.User.create/3)
    end

    field :authenticate, type: :user do
      arg :input, non_null(:login_input)
      resolve(&Resolver.Auth.create/3)
    end
  end
end
