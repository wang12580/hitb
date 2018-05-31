defmodule Block.Edit.Repo.Migrations.CreateMyMould do
  use Ecto.Migration

  def change do
    create table(:my_mould) do
      add :username, :string
      add :name, :string
      add :content, :string
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end

  end
end
