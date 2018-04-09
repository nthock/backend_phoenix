defmodule GraphQL.Schema.UserType do
  defmacro __using__(_opts) do
    quote do
      object :user do
        field :id, :id
        field :name, :string
        field :email, :string
        field :designation, :string
        field :contact_number, :string
        field :slug, :string
        field :super_admin, :boolean
        field :admin, :boolean
      end
    end
  end
end
