defmodule Hospitals.Repo.Migrations.CreateCwzbWbzg do
  use Ecto.Migration

  def change do
    create table(:cwzb_wbzg) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :wbzg_rate, :float
      add :wbzgzf_rate, :float
      add :wbzgyl_rate, :float
      add :wbzgyj_rate, :float
      add :wbzgypj_rate, :float
      add :wbzghl_rate, :float
      add :wbzggl_rate, :float
      timestamps()
    end
  end
end
