defmodule Hospitals.Repo.Migrations.CreateTifxHzly do
  use Ecto.Migration

  def change do
    create table(:tjfx_hzly) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :man_num, :integer
      add :man_rate, :float
      add :woman_num, :integer
      add :woman_rate, :float
      add :bd_num, :integer
      add :bd_rate, :float
      add :wd_num, :integer
      add :wd_rate, :float
      timestamps()
    end
  end
end
