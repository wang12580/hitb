defmodule Hospitals.Repo.Migrations.CreateTifxSimz do
  use Ecto.Migration

  def change do
    create table(:tjfx_sjmz) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :bc_rate, :float
      add :yz_rate, :float
      add :qg_rate, :float
      add :zp_rate, :float
      add :per_rate, :float
      add :jg_rate, :float
      add :xy_rate, :float
      add :n_rate, :float
      timestamps()
    end
  end
end
