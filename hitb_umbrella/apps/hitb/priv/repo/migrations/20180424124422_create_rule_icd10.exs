defmodule Hitb.Library.Repo.Migrations.CreateRuleIcd10 do
  use Ecto.Migration

  def change do
    create table(:rule_icd10) do
      add :code, :string
      add :name, :string
      add :codes, {:array, :string}
      add :icdcc, :string
      add :dissect, :string
      add :icdc, :string
      add :icdc_az, :string
      add :adrg, {:array, :string}
      add :mdc, {:array, :string}
      add :cc, :boolean, default: false
      add :nocc_1, {:array, :string}
      add :nocc_a, {:array, :string}
      add :nocc_aa, {:array, :string}
      add :mcc, :boolean, default: false
      add :org, :string
      add :year, :string
      add :version, :string
      add :plat, :string
      timestamps()
    end

  end
end
