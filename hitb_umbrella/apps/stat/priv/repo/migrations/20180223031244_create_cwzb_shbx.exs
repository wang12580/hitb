defmodule Hospitals.Repo.Migrations.CreateCwzbSnbx do
  use Ecto.Migration

  def change do
    create table(:cwzb_shbx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :qtbx_rate, :float
      add :qtbxzf_rate, :float
      add :qtbxyl_rate, :float
      add :qtbxyj_rate, :float
      add :qtbxypj_rate, :float
      add :qtbxhl_rate, :float
      add :qtbxgl_rate, :float
      timestamps()
    end
  end
end
