defmodule Hospitals.Repo.Migrations.CreateCwzbPkjz do
  use Ecto.Migration

  def change do
    create table(:cwzb_pkjz) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :pkjz_rate, :float
      add :pkjzzf_rate, :float
      add :pkjzyl_rate, :float
      add :pkjzyj_rate, :float
      add :pkjzypj_rate, :float
      add :pkjzhl_rate, :float
      add :pkjzgl_rate, :float
      timestamps()
    end
  end
end
