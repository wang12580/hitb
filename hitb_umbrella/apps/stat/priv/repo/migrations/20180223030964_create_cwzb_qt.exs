defmodule Hospitals.Repo.Migrations.CreateCwzbQt do
  use Ecto.Migration

  def change do
    create table(:cwzb_qt) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :qthz_rate, :float
      add :qthzzf_rate, :float
      add :qthzyl_rate, :float
      add :qthzyj_rate, :float
      add :qthzypj_rate, :float
      add :qthzhl_rate, :float
      add :qthzgl_rate, :float
      timestamps()
    end
  end
end
