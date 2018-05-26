defmodule Hitb.Edit.Repo.Migrations.CreateClinetHelp do
    use Ecto.Migration

    def change do
      create table(:clinet_help) do
        add :name, :string
        add :content, :string
        timestamps()
      end

    end
  end
