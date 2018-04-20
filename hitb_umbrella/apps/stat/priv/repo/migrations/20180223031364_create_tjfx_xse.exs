defmodule Hospitals.Repo.Migrations.CreateTifxXse do
  use Ecto.Migration

  def change do
    create table(:tjfx_xse) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :baby_num, :integer
      add :baby_rate, :float
      add :boy_num, :integer
      add :boy_rate, :float
      add :girl_num, :integer
      add :girl_rate, :float
      add :def_num, :integer
      add :def_rate, :float
      timestamps()
    end
  end
end
