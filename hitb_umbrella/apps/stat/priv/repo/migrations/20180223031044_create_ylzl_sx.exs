defmodule Hospitals.Repo.Migrations.CreateYlzlSx do
  use Ecto.Migration

  def change do
    create table(:ylzl_sx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :sxfxsj_rate, :float
      add :sxyw_rate, :float
      add :sxyl_rate, :float
      add :sxyf_rate, :float
      add :sxwr_rate, :float
      add :sxgl_rate, :float
      timestamps()
    end
  end
end
