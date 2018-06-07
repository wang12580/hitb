defmodule Hitb.Library.Repo.Migrations.LibraryFile do
    use Ecto.Migration

    def change do
      create table(:library_file) do
        add :file_name, :string #一级分类

        timestamps()
      end

    end
  end
