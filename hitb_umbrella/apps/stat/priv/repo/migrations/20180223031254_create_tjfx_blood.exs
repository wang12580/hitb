defmodule Hospitals.Repo.Migrations.CreateTifxBlood do
  use Ecto.Migration

  def change do
    create table(:tjfx_blood) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :blood_rate, :float
      add :ablood_rate, :float
      add :bblood_rate, :float
      add :abblood_rate, :float
      add :oblood_rate, :float
      add :wcblood_rate, :float
      timestamps()
    end
  end
end
