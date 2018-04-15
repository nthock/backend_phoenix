defmodule GraphQL.Schema.Types do
  use Absinthe.Schema.Notation

  use GraphQL.Schema.{UserType}

  object :errors do
    field :key, :string
    field :value, :string
  end
end
