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
end
