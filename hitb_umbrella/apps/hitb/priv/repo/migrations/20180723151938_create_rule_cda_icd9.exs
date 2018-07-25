defmodule Hitb.Library.Repo.Migrations.RuleCdaIcd9 do
    use Ecto.Migration

    def change do
      create table(:rule_cda_icd9) do
        add :code, :string, size: 1000000 #编码
        add :name, :string, size: 1000000 #名称
        add :symptom, {:array, :string} #主诉 症状
        timestamps()
      end
      # create unique_index(:stat_cda, [:items])
    end
  end
