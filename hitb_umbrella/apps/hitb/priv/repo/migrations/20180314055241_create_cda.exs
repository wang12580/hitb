defmodule Hitb.Edit.Repo.Migrations.CreateCda do
  use Ecto.Migration

  def change do
    create table(:cda) do
      add :username, :string
      add :patient_id, :string
      add :name, :string
      add :content, :string
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      timestamps()
    end

  end
end
