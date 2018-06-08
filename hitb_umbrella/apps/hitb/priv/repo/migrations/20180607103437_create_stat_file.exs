defmodule Hitb.Library.Repo.Migrations.StatFile do
    use Ecto.Migration

    def change do
      create table(:stat_file) do
        add :first_menu, :string
        add :second_menu, :string
        add :file_name, :string
        add :page_type, :string
        timestamps()
      end

    end
  end
