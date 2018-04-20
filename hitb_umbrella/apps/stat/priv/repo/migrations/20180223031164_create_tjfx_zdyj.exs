defmodule Hospitals.Repo.Migrations.CreateTifxZdyj do
  use Ecto.Migration

  def change do
    create table(:tjfx_zdyj) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :lczg_rate, :float
      add :xxct_rate, :float
      add :sszd_rate, :float
      add :shmy_rate, :float
      add :xbx_rate, :float
      add :bljf_rate, :float
      add :blyf_rate, :float
      add :sjybl_rate, :float
      add :zgzdyj_rate, :float
      timestamps()
    end
  end
end
