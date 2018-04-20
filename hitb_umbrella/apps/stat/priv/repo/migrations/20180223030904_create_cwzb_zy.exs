defmodule Hospitals.Repo.Migrations.CreateCwzbZy do
  use Ecto.Migration

  def change do
    create table(:cwzb_zy) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :zc_expense, :float
      add :zcy_expense, :float
      add :avg_zc, :float
      add :avg_zcy, :float
      add :zc_rate, :float
      add :zcy_rate, :float
      timestamps()
    end
  end
end
