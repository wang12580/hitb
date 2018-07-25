defmodule Hitb.Library.Repo.Migrations.RulePharmacy do
    use Ecto.Migration

    def change do
      create table(:rule_pharmacy) do
        add :pharmacy, :string, size: 1000000 #用药
        add :icd10_a, {:array, :string} #icd10_a
        add :symptom, {:array, :string} #主诉 症状
        timestamps()
      end
      # create unique_index(:stat_cda, [:items])
    end
  end
