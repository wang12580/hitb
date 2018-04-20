defmodule Hospitals.Repo.Migrations.CreateCwzbGf do
  use Ecto.Migration

  def change do
    create table(:cwzb_gf) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :qgf_rate, :float
      add :qgfzf_rate, :float
      add :qgfyl_rate, :float
      add :qgfyj_rate, :float
      add :qgfypj_rate, :float
      add :qgfhl_rate, :float
      add :qgfgl_rate, :float
      timestamps()
    end
  end
end
