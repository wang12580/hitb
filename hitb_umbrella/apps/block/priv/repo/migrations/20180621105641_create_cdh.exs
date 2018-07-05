defmodule Block.Library.Repo.Migrations.Cdh do
  use Ecto.Migration

  def change do
    create table(:cdh) do
      add :key, :string
      add :value, :string, size: 10485760
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end
    create unique_index(:cdh, [:key])
  end
end
