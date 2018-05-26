defmodule Hitb.Library.Repo.Migrations.CreateRuleDrg do
  use Ecto.Migration

  def change do
    create table(:rule_drg) do
      add :code, :string
      add :name, :string
      add :mdc, :string
      add :adrg, :string
      add :org, :string
      add :year, :string
      add :version, :string
      add :plat, :string
      timestamps()
    end

  end
end
