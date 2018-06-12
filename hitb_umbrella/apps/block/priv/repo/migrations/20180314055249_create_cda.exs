defmodule Block.Edit.Repo.Migrations.CreateCda do
  use Ecto.Migration

  def change do
    create table(:cda) do
      add :username, :string
      add :name, :string
      add :content, :string, size: 100000
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end

  end
end
