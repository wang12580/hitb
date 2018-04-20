defmodule Hospitals.Repo.Migrations.CreateTifxCsts do
  use Ecto.Migration

  def change do
    create table(:tjfx_csts) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :dt_num, :integer
      add :dt_rate, :float
      add :sbt_num, :integer
      add :sbt_rate, :float
      add :dbt_num, :integer
      add :dbt_rate, :float
      add :st_num, :integer
      add :st_rate, :float
      timestamps()
    end
  end
end
