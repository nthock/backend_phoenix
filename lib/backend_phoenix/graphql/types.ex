defmodule GraphQL.Schema.Types do
  use Absinthe.Schema.Notation

  use GraphQL.Schema.{UserType}

  object :errors do
    field(:key, :string)
    field(:value, :string)
  end

  input_object :login_input do
    field(:email, :string)
    field(:password, :string)
  end
end
