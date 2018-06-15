defmodule Hitb.Edit.Repo.Migrations.CreateMyMould do
  use Ecto.Migration

  def change do
    create table(:my_mould) do
      add :username, :string
      add :name, :string
      add :content, :string
      add :header, :string
      add :is_change, :boolean, default: false
      add :is_show, :boolean, default: false
      timestamps()
    end

  end
end
