defmodule Hospitals.Repo.Migrations.CreateTifxSsjb do
  use Ecto.Migration

  def change do
    create table(:tjfx_ssjb) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ojss_num, :integer
      add :ojss_rate, :float
      add :wjss_num, :integer
      add :wjss_rate, :float
      add :tjss_num, :integer
      add :tjss_rate, :float
      add :fjss_num, :integer
      add :fjss_rate, :float
      timestamps()
    end
  end
end
