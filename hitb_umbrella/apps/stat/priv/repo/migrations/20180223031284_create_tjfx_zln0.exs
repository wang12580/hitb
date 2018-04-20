defmodule Hospitals.Repo.Migrations.CreateTifxZln0 do
  use Ecto.Migration

  def change do
    create table(:tjfx_zln0) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :nl_rate, :float
      add :no_rate, :float
      add :nw_rate, :float
      add :nt_rate, :float
      add :nf_rate, :float
      add :wfpglb_rate, :float
      timestamps()
    end
  end
end
