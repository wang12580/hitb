defmodule Hospitals.Repo.Migrations.CreateYlzlYw do
  use Ecto.Migration

  def change do
    create table(:ylzl_yw) do
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
