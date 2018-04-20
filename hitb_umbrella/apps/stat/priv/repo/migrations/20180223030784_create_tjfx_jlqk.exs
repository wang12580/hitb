defmodule Hospitals.Repo.Migrations.CreateTifxJlqk do
  use Ecto.Migration

  def change do
    create table(:tjfx_jlqk) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yjqk_num, :integer
      add :yjqk_rate, :float
      add :ejqk_num, :integer
      add :ejqk_rate, :float
      add :sjqk_num, :integer
      add :sjqk_rate, :float
      timestamps()
    end
  end
end
