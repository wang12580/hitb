defmodule Hitb.Library.Repo.Migrations.CreateRuleIcd9 do
  use Ecto.Migration

  def change do
    create table(:rule_icd9) do
      add :code, :string
      add :name, :string
      add :codes, {:array, :string}
      add :icdcc, :string
      add :icdc, :string
      add :dissect, :string
      add :adrg, {:array, :string}
      add :p_type, :integer
      add :property, :string
      add :option, :string
      add :org, :string
      add :year, :string
      add :version, :string
      add :plat, :string
      timestamps()
    end

  end
end
