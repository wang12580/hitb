defmodule Hospitals.Repo.Migrations.CreateTifxTbxb do
  use Ecto.Migration

  def change do
    create table(:tjfx_tbxb) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :txb_num, :integer
      add :txb_rate, :float
      add :bxb_num, :integer
      add :bxb_rate, :float
      add :ftfbxb_num, :integer
      add :ftfbxb_rate, :float
      add :nk_num, :integer
      add :nk_rate, :float
      timestamps()
    end
  end
end
