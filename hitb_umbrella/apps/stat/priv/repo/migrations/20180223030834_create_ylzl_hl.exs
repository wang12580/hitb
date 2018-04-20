defmodule Hospitals.Repo.Migrations.CreateYlzlHl do
  use Ecto.Migration

  def change do
    create table(:ylzl_hl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :hlfxsj_rate, :float
      add :syyw_rate, :float
      add :syyl_rate, :float
      add :syyf_rate, :float
      add :syry_rate, :float
      add :sywr_rate, :float
      add :sygl_rate, :float
      timestamps()
    end
  end
end
