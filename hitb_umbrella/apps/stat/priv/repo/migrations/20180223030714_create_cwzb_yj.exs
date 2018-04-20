defmodule Hospitals.Repo.Migrations.CreateCwzbYj do
  use Ecto.Migration

  def change do
    create table(:cwzb_yj) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :hsjc_rate, :float
      add :hszl_rate, :float
      add :csf_rate, :float
      add :fsf_rate, :float
      add :hyf_rate, :float
      add :blf_rate, :float
      timestamps()
    end
  end
end
