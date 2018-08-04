defmodule BackendPhoenix.Accounts.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BackendPhoenix.Accounts.Users
  alias BackendPhoenix.Accounts.Schema.User

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:encrypted_password, :string)
    field(:designation, :string)
    field(:contact_number, :string)
    field(:slug, :string)
    field(:super_admin, :boolean)
    field(:admin, :boolean)
    field(:reset_password_token, :string)
    field(:reset_password_sent_at, :utc_datetime)
    field(:invitation_token, :string)
    field(:invitation_created_at, :utc_datetime)
    field(:invitation_sent_at, :utc_datetime)
    field(:invitation_accepted, :boolean)
    field(:invitation_accepted_at, :utc_datetime)
    field(:invitation_limit, :integer)
    field(:invited_by_id, :integer)
    field(:invited_by_type, :string)
    field(:errors, {:array, :map}, default: [], virtual: true)

    timestamps()
  end

  @valid_attrs [:name, :email, :password, :password_confirmation, :designation, :contact_number]
  @invitation_attrs [:invited_by_id, :invitation_created_at, :invitation_token, :email, :name]
  @required_attrs [:email]

  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> validate_format(:email, ~r/(\w+)@([\w.]+)/)
    |> password_changeset()
  end

  def admin_changeset(%User{} = user, attrs) do
    user
    |> registration_changeset(attrs)
    |> put_change(:admin, true)
  end

  def admin_invitation_changeset(%User{} = user, attrs, inviter_id) do
    user
    |> cast(attrs, @valid_attrs)
    |> put_change(:invited_by_id, inviter_id)
    |> put_change(:invitation_created_at, Timex.now)
    |> put_change(:invitation_token, create_invitation_token(attrs, inviter_id))
    |> validate_required(@invitation_attrs)
    |> ensure_inviter_super_admin(inviter_id)
  end

  def admin_accept_invitation_changeset(user, _attrs) when is_nil(user) do
    %User{}
    |> cast(%{}, @valid_attrs)
    |> add_error(:id, "not a valid user")
  end

  def admin_accept_invitation_changeset(%User{} = user, attrs) do
    user
    |> registration_changeset(attrs)
    |> put_change(:invitation_accepted, true)
    |> put_change(:invitation_token, nil)
    |> put_change(:invitation_accepted_at, Timex.now)
  end

  def forget_password_changeset(user) when is_nil(user) do
    %User{}
    |> cast(%{}, @valid_attrs)
    |> add_error(:id, "not a valid user")
  end

  def forget_password_changeset(%User{} = user) do
    user
    |> cast(%{}, @valid_attrs)
    |> put_change(:reset_password_token, create_reset_password_token())
    |> put_change(:reset_password_sent_at, Timex.now)
    |> validate_required([:reset_password_token, :reset_password_sent_at])
  end

  def reset_password_changeset(user, _attrs) when is_nil(user) do
    %User{}
    |> cast(%{}, @valid_attrs)
    |> add_error(:id, "not a valid user")
  end

  def reset_password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @valid_attrs)
    |> password_changeset()
    |> put_change(:reset_password_token, nil)
    |> put_change(:reset_password_sent_at, nil)
  end

  defp ensure_inviter_super_admin(changeset, inviter_id) do
    validate_change changeset, :invited_by_id, fn _, _ ->
      inviter_id
      |> Users.get!()
      |> check_super_admin()
    end
  end

  defp password_changeset(changeset) do
    changeset
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "does not match")
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  defp create_invitation_token(%{email: email}, inviter_id) do
    :crypto.hmac(:sha256, "BackendPhoenix", "#{email} #{inviter_id} #{Timex.now}")
    |> Base.encode16(case: :lower)
  end

  defp create_invitation_token(_attrs, _inviter_id), do: "some_random_token"

  defp create_reset_password_token() do
    :crypto.hmac(:sha256, "BackendPhoenixRestPW", "Reset Password: #{Timex.now}")
    |> Base.encode16(case: :lower)
  end

  defp check_super_admin(%{super_admin: true}) do
    []
  end

  defp check_super_admin(_user) do
    [invited_by_id: "Must be a super_admin"]
  end
end
