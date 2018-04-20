defmodule Hospitals.Repo.Migrations.CreateTifxMz do
  use Ecto.Migration

  def change do
    create table(:tjfx_mz) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :mz_rate, :float
      add :wmz_rate, :float
      add :qsmz_rate, :float
      add :xrmz_rate, :float
      add :jmmz_rate, :float
      add :jcmz_rate, :float
      add :qymz_rate, :float
      add :zgnmz_rate, :float
      timestamps()
    end
  end
end
