defmodule Hospitals.Repo.Migrations.CreateTifxFhmz do
  use Ecto.Migration

  def change do
    create table(:tjfx_fhmz) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ymwfh_rate, :float
      add :fhmz_rate, :float
      add :btywfh_rate, :float
      add :btfffh_rate, :float
      add :tsfffh_rate, :float
      add :jxfh_rate, :float
      add :qtmz_rate, :float
      timestamps()
    end
  end
end
