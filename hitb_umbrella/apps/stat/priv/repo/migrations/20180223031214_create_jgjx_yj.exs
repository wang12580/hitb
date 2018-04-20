defmodule Hospitals.Repo.Migrations.CreateJgjxYj do
  use Ecto.Migration

  def change do
    create table(:jgjx_yj) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yjsy_rate, :float
      add :hsjc_rate, :float
      add :hszl_rate, :float
      add :cszl_rate, :float
      add :fszl_rate, :float
      add :hy_rate, :float
      add :bl_rate, :float
      timestamps()
    end
  end
end
