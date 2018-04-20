defmodule Hospitals.Repo.Migrations.CreateTifxQtqk do
  use Ecto.Migration

  def change do
    create table(:tjfx_qtqk) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :yss_num, :integer
      add :yss_rate, :float
      add :yjqtqk_num, :integer
      add :yjqtqk_rate, :float
      add :ejqtqk_num, :integer
      add :ejqtqk_rate, :float
      add :sjqtqk_num, :integer
      add :sjqtqk_rate, :float
      timestamps()
    end
  end
end
