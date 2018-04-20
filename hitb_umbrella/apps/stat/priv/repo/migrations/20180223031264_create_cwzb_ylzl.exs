defmodule Hospitals.Repo.Migrations.CreateCwzbYlzl do
  use Ecto.Migration

  def change do
    create table(:cwzb_ylzl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :jrzlf_rate, :float
      add :tszlf_rate, :float
      add :kfzlf_rate, :float
      add :zyzlf_rate, :float
      add :ybzlf_rate, :float
      add :jszlf_rate, :float
      add :wlzlf_rate, :float
      timestamps()
    end
  end
end
