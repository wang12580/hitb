defmodule Hospitals.Repo.Migrations.CreateCwzbWbnc do
  use Ecto.Migration

  def change do
    create table(:cwzb_wbnc) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :wbxnh_rate, :float
      add :wbxnhzf_rate, :float
      add :wbxnhyl_rate, :float
      add :wbxnhyj_rate, :float
      add :wbxnhypj_rate, :float
      add :wbxnhhl_rate, :float
      add :wbxnhgl_rate, :float
      timestamps()
    end
  end
end
