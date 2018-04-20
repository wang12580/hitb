defmodule Hospitals.Repo.Migrations.CreateYlzlYc do
  use Ecto.Migration

  def change do
    create table(:ylzl_yc) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ychz_rate, :float
      add :odyc_rate, :float
      add :wdyc_rate, :float
      add :tdyc_rate, :float
      add :fdyc_rate, :float
      timestamps()
    end
  end
end
