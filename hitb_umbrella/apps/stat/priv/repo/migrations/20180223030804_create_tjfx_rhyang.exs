defmodule Hospitals.Repo.Migrations.CreateTifxRhyang do
  use Ecto.Migration

  def change do
    create table(:tjfx_rhyang) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rhyxa_cc, :integer
      add :rhyxb_cc, :integer
      add :rhyxab_cc, :integer
      add :rhyxo_cc, :integer
      add :rhyxacc_rate, :float
      add :rhyxbcc_rate, :float
      add :rhyxabcc_rate, :float
      add :rhyx0cc_rate, :float
      timestamps()
    end
  end
end
