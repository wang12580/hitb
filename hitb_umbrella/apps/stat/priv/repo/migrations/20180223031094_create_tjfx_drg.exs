defmodule Hospitals.Repo.Migrations.CreateTifxDrg do
  use Ecto.Migration

  def change do
    create table(:tjfx_drg) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      timestamps()
    end
  end
end
