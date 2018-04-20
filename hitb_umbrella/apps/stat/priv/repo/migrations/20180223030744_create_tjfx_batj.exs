defmodule Hospitals.Repo.Migrations.CreateTifxBatj do
  use Ecto.Migration

  def change do
    create table(:tjfx_batj) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ssls_rate, :float
      add :mzzy_rate, :float
      add :jzzy_rate, :float
      add :ybzf_rate, :float
      add :xnh_rate, :float
      add :qzfbl_rate, :float
      add :qgfbl_rate, :float
      timestamps()
    end
  end
end
