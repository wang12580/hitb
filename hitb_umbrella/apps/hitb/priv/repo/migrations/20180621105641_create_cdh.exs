defmodule Hitb.Library.Repo.Migrations.Cdh do
    use Ecto.Migration

    def change do
      create table(:cdh) do
        add :key, :string
        add :value, :string, size: 100000
        add :username, :string, size: 100000
        timestamps()
      end

    end
  end
