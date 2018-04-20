defmodule Hospitals.Repo.Migrations.CreateBase do
  use Ecto.Migration

  def change do
    create table(:base) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :weight_count, :float
      add :zdxg_num, :integer
      add :fee_index, :float
      add :day_index, :float
      add :cmi, :float
      add :fee_avg, :float
      add :day_avg, :float
      timestamps()
    end
  end
end
