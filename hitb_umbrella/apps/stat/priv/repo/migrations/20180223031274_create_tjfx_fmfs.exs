defmodule Hospitals.Repo.Migrations.CreateTifxFmfs do
  use Ecto.Migration

  def change do
    create table(:tjfx_fmfs) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ck_num, :integer
      add :ck_rate, :float
      add :pgc_num, :integer
      add :pgc_rate, :float
      add :sc_num, :integer
      add :sc_rate, :float
      timestamps()
    end
  end
end
