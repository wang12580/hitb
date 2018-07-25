defmodule Hitb.Library.Repo.Migrations.RuleSymptom do
    use Ecto.Migration

    def change do
      create table(:rule_symptom) do
        add :symptom, :string, size: 1000000 #主诉 症状
        add :icd9_a, {:array, :string} #icd9_a
        add :icd10_a, {:array, :string} #icd10_a
        add :pharmacy, {:array, :string} #用药
        timestamps()
      end
      # create unique_index(:stat_cda, [:items])
    end
  end
