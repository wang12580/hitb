defmodule Hitb.Library.Repo.Migrations.StatFile do
    use Ecto.Migration

    def change do
      create table(:stat_file) do
        add :first_menu, :string
        add :second_menu, :string
        add :file_name, :string
        add :page_type, :string
        add :insert_user, :string #一级分类
        add :update_user, :string #一级分类
        add :header, :string #一级分类
        timestamps()
      end

    end
  end
