defmodule Hitb.Library.Repo.Migrations.LibraryFile do
    use Ecto.Migration

    def change do
      create table(:library_file) do
        add :file_name, :string #一级分类
        add :insert_user, :string #一级分类
        add :update_user, :string #一级分类
        add :header, :string #一级分类
        timestamps()
      end

    end
  end
