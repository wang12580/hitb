defmodule Hospitals.Repo.Migrations.CreateTifxQtzz do
  use Ecto.Migration

  def change do
    create table(:tjfx_qtzz) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :zwmx_num, :integer
      add :zwmx_rate, :float
      add :ymw_num, :integer
      add :ymw_rate, :float
      add :jc_num, :integer
      add :jc_rate, :float
      add :sj_num, :integer
      add :sj_rate, :float
      timestamps()
    end
  end
end
