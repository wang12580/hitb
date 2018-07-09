defmodule Block.Edit.Repo.Migrations.CreateCda do
  use Ecto.Migration

  def change do
    create table(:cda) do
      add :username, :string
      add :patient_id, :string
      add :name, :string
      add :content, :string, size: 10485760
      add :previous_hash, :string
      add :hash, :string
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      add :header, :string, default: false
      timestamps()
    end
    create unique_index(:cda, [:patient_id])

  end
end
