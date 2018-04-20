defmodule Hospitals.Repo.Migrations.CreateCwzbXy do
  use Ecto.Migration

  def change do
    create table(:cwzb_xy) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :sxf_rate, :float
      add :xyf_rate, :float
      add :kjy_rate, :float
      add :bdb_rate, :float
      add :qdb_rate, :float
      add :nxyz_rate, :float
      add :xbyz_rate, :float
      timestamps()
    end
  end
end
