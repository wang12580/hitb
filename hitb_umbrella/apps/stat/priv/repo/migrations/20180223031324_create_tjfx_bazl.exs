defmodule Hospitals.Repo.Migrations.CreateTifxBazl do
  use Ecto.Migration

  def change do
    create table(:tjfx_bazl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :bazlj_num, :integer
      add :bazlj_rate, :float
      add :bazly_num, :integer
      add :bazly_rate, :float
      add :bazlb_num, :integer
      add :bazlb_rate, :float
      timestamps()
    end
  end
end
