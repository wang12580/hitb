defmodule Block.Repo.Migrations.CreateCda do
  use Ecto.Migration

  def change do
    create table(:cda) do
      add :content, :string
      add :name, :string
      add :username, :string
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      timestamps()
    end
  end

end
