defmodule Hospitals.Repo.Migrations.CreateTifxNrh do
  use Ecto.Migration

  def change do
    create table(:tjfx_nrh) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rhbxa_num, :integer
      add :rhbxa_rate, :float
      add :rhbxb_num, :integer
      add :rhbxb_rate, :float
      add :rhbxo_num, :integer
      add :rhbxo_rate, :float
      add :rhbxab_num, :integer
      add :rhbxab_rate, :float
      timestamps()
    end
  end
end
