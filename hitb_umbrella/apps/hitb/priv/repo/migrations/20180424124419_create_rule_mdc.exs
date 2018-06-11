defmodule Hitb.Library.Repo.Migrations.CreateRuleMdc do
  use Ecto.Migration

  def change do
    create table(:rule_mdc) do
      add :code, :string
      add :name, :string
      add :mdc, :string
      add :icd9_a, {:array, :string}
      add :icd9_aa, {:array, :string}
      add :icd10_a, {:array, :string}
      add :icd10_aa, {:array, :string}
      add :org, :string
      add :year, :string
      add :version, :string
      add :plat, :string

      timestamps()
    end

  end
end
