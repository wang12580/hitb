defmodule Hospitals.Repo.Migrations.CreateYlzlSszl do
  use Ecto.Migration

  def change do
    create table(:ylzl_sszl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :sqday_num, :integer
      add :shday_num, :integer
      add :fjh_num, :integer
      add :fjh_rate, :float
      add :zdss_num, :integer
      add :sw_num, :integer
      add :sw_rate, :float
      timestamps()
    end
  end
end
