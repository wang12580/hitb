defmodule Hospitals.Repo.Migrations.CreateTifxYlqk do
  use Ecto.Migration

  def change do
    create table(:tjfx_ylqk) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yjyqk_num, :integer
      add :yjyqk_rate, :float
      add :ejyqk_num, :integer
      add :ejyqk_rate, :float
      add :sjyqk_num, :integer
      add :sjyqk_rate, :float
      timestamps()
    end
  end
end
