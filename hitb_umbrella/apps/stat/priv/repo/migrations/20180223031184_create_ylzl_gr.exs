defmodule Hospitals.Repo.Migrations.CreateYlzlGr do
  use Ecto.Migration

  def change do
    create table(:ylzl_gr) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :szh_rate, :float
      add :czh_rate, :float
      add :ssh_rate, :float
      add :stx_rate, :float
      add :rgjt_rate, :float
      add :ylqj_rate, :float
      timestamps()
    end
  end
end
