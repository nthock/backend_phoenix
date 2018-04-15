defmodule BackendPhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BackendPhoenix.Accounts.User

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :designation, :string
    field :contact_number, :string
    field :slug, :string
    field :super_admin, :boolean
    field :admin, :boolean
    field :errors, {:array, :map}, default: [], virtual: true

    timestamps()
  end

  @valid_attrs [:name, :email, :password, :password_confirmation, :designation, :contact_number]
  @required_attrs [:email]

  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> validate_format(:email, ~r/(\w+)@([\w.]+)/)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match")
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password} } ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
