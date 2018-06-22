defmodule Block.Library.Repo.Migrations.Cdh do
  use Ecto.Migration

  def change do
    create table(:cdh) do
      add :content, :string, size: 10485760
      add :name, :string
      add :type, :string
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end
  end
end
