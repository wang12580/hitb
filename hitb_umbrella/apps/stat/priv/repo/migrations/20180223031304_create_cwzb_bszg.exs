defmodule Hospitals.Repo.Migrations.CreateCwzbBszg do
  use Ecto.Migration

  def change do
    create table(:cwzb_bszg) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :bszg_rate, :float
      add :bszgzf_rate, :float
      add :bszgyl_rate, :float
      add :bszgyj_rate, :float
      add :bszgypj_rate, :float
      add :bszghl_rate, :float
      add :bszggl_rate, :float
      timestamps()
    end
  end
end
