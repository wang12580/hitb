defmodule Hitb.Library.Repo.Migrations.CreateRuleAdrg do
  use Ecto.Migration

  def change do
    create table(:rule_adrg) do
      add :code, :string
      add :name, :string
      add :drgs_1, {:array, :string}
      add :icd10_a, {:array, :string}
      add :icd10_aa, {:array, :string}
      add :icd10_acc, {:array, :string}
      add :icd10_b, {:array, :string}
      add :icd10_bb, {:array, :string}
      add :icd10_bcc, {:array, :string}
      add :icd9_a, {:array, :string}
      add :icd9_aa, {:array, :string}
      add :icd9_acc, {:array, :string}
      add :icd9_b, {:array, :string}
      add :icd9_bb, {:array, :string}
      add :icd9_bcc, {:array, :string}
      add :mdc, :string
      add :org, :string
      add :year, :string
      add :version, :string
      add :plat, :string
      timestamps()
    end

  end
end
