defmodule GraphQL.Schema do
  use Absinthe.Schema
  alias GraphQL.Resolver
  alias GraphQL.Schema.Middleware
  import_types(GraphQL.Schema.Types)

  query do
    field :get_users, type: list_of(:user) do
      resolve(&Resolver.User.list/3)
    end
  end

  mutation do
    field :create_user, type: :user do
      arg :input, non_null(:user_input)
      resolve(&Resolver.User.create/3)
    end
  end
end
