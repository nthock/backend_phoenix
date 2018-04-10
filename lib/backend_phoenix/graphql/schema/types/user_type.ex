defmodule GraphQL.Schema.UserType do
  defmacro __using__(_opts) do
    quote do
      object :user do
        field :id, :id
        field :name, :string
        field :email, :string
        field :designation, :string
        field :contact_number, :string
        field :token, :string
        field :status, :string
        field :slug, :string
        field :super_admin, :boolean
        field :admin, :boolean
        field :errors, list_of(:errors)
      end

      input_object :user_input do
        field :name, :string
        field :email, :string
        field :password, :string
        field :password_confirmation, :string
      end
    end
  end
end
