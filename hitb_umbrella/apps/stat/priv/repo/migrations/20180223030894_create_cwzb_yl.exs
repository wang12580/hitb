defmodule Hospitals.Repo.Migrations.CreateCwzbYl do
  use Ecto.Migration

  def change do
    create table(:cwzb_yl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yl_rate, :float
      add :zlf_rate, :float
      add :ybjcf_rate, :float
      add :jsf_rate, :float
      add :mzf_rate, :float
      add :ssf_rate, :float
      timestamps()
    end
  end
end
