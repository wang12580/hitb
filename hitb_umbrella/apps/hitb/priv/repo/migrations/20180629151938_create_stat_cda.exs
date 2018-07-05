defmodule Hitb.Library.Repo.Migrations.StatCda do
    use Ecto.Migration

    def change do
      create table(:stat_cda) do
        add :items, :string, size: 1000000
        add :num, :integer
        add :patient_id, {:array, :string}
        timestamps()
      end
      create unique_index(:stat_cda, [:items])
    end
  end
