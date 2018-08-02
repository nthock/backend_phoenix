defmodule BackendPhoenix.Repo.Migrations.AddColumnsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reset_password_token, :string
      add :reset_password_sent_at, :string
      add :invitation_token, :string
      add :invitation_created_at, :utc_datetime
      add :invitation_sent_at, :utc_datetime
      add :invitation_accepted, :boolean, default: false
      add :invitation_accepted_at, :boolean
      add :invitation_limit, :integer
      add :invited_by_id, :integer
      add :invited_by_type, :string
    end

    create index(:users, [:invitation_token])
    create index(:users, [:reset_password_token])
  end
end
