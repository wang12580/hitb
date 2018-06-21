defmodule Hitb.Library.Repo.Migrations.Cdh do
    use Ecto.Migration

    def change do
      create table(:cdh) do
        add :content, :string
        add :name, :string
        add :type, :string
        timestamps()
      end

    end
  end
