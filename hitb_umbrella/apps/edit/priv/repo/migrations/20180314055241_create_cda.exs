defmodule Edit.Repo.Migrations.CreateCda do
  use Ecto.Migration

  def change do
    create table(:cda) do
      add :username, :string
      add :name, :string
      add :content, :string

      timestamps()
    end

  end
end
