defmodule Hospitals.Repo.Migrations.CreateCwzbHc do
  use Ecto.Migration

  def change do
    create table(:cwzb_hc) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yp_rate, :float
      add :zlyc_rate, :float
      add :jryc_rate, :float
      add :ssyc_rate, :float
      add :jcyc_rate, :float
      add :hc_rate, :float
      timestamps()
    end
  end
end
