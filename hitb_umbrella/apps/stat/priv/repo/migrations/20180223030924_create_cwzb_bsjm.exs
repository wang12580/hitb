defmodule Hospitals.Repo.Migrations.CreateCwzbBsjm do
  use Ecto.Migration

  def change do
    create table(:cwzb_bsjm) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :bsjm_rate, :float
      add :bsjmzf_rate, :float
      add :bsjmyl_rate, :float
      add :bsjmyj_rate, :float
      add :bsjmypj_rate, :float
      add :bsjmhl_rate, :float
      add :bsjmgl_rate, :float
      timestamps()
    end
  end
end
