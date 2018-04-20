defmodule Hospitals.Repo.Migrations.CreateTifxRhyang2 do
  use Ecto.Migration

  def change do
    create table(:tjfx_rhyang2) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rhyxa_num, :integer
      add :rhyxa_rate, :float
      add :rhyxb_num, :integer
      add :rhyxb_rate, :float
      add :rhyxo_num, :integer
      add :rhyxo_rate, :float
      add :rhyxab_num, :integer
      add :rhyxab_rate, :float
      timestamps()
    end
  end
end
