defmodule Hospitals.Repo.Migrations.CreateTifxFh do
  use Ecto.Migration

  def change do
    create table(:tjfx_fh) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :zlfq_rate, :float
      add :gfh_rate, :float
      add :zfh_rate, :float
      add :dfh_rate, :float
      add :wfh_rate, :float
      add :wqd_rate, :float
      timestamps()
    end
  end
end
