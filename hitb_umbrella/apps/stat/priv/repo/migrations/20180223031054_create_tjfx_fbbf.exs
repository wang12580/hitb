defmodule Hospitals.Repo.Migrations.CreateTifxFbbf do
  use Ecto.Migration

  def change do
    create table(:tjfx_fbbf) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :xhxt_rate, :float
      add :sjxt_rate, :float
      add :hxxt_rate, :float
      add :xyxh_rate, :float
      add :ydxt_rate, :float
      add :nfm_rate, :float
      add :mnxt_rate, :float
      add :szxt_rate, :float
      timestamps()
    end
  end
end
