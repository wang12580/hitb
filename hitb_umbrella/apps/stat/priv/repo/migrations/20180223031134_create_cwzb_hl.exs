defmodule Hospitals.Repo.Migrations.CreateCwzbHl do
  use Ecto.Migration

  def change do
    create table(:cwzb_hl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :hlze_num, :integer
      add :hlzl_num, :integer
      add :hlf_num, :integer
      add :hlzl_avg, :float
      add :hlf_avg, :float
      add :hlze_rate, :float
      add :hlzl_rate, :float
      add :hlf_rate, :float
      timestamps()
    end
  end
end
