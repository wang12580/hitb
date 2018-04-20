defmodule Hospitals.Repo.Migrations.CreateTifxZlt0 do
  use Ecto.Migration

  def change do
    create table(:tjfx_zlt0) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :tl_rate, :float
      add :to_rate, :float
      add :tw_rate, :float
      add :tt_rate, :float
      add :tf_rate, :float
      add :wfpgyf_rate, :float
      timestamps()
    end
  end
end
