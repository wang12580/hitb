defmodule Hospitals.Repo.Migrations.CreateCwzbGl do
  use Ecto.Migration

  def change do
    create table(:cwzb_gl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :glze_rate, :float
      add :jhfzf_rate, :float
      add :cwf_rate, :float
      add :ghf_rate, :float
      add :syf_rate, :float
      add :otherf_rate, :float
      timestamps()
    end
  end
end
