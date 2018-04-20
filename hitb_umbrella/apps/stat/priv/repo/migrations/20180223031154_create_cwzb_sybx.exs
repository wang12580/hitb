defmodule Hospitals.Repo.Migrations.CreateCwzbSybx do
  use Ecto.Migration

  def change do
    create table(:cwzb_sybx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :sybx_rate, :float
      add :sybxzf_rate, :float
      add :sybxyl_rate, :float
      add :sybxyj_rate, :float
      add :sybxypj_rate, :float
      add :sybxhl_rate, :float
      add :sybxgl_rate, :float
      timestamps()
    end
  end
end
