defmodule Hospitals.Repo.Migrations.CreateCwzbZf do
  use Ecto.Migration

  def change do
    create table(:cwzb_zf) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :qzf_rate, :float
      add :qzfyl_rate, :float
      add :qzfyj_rate, :float
      add :qzfypj_rate, :float
      add :qzfhl_rate, :float
      add :qzfgl_rate, :float
      timestamps()
    end
  end
end
