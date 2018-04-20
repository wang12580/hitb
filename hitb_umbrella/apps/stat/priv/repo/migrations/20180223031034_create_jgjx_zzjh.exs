defmodule Hospitals.Repo.Migrations.CreateJgjxZzjh do
  use Ecto.Migration

  def change do
    create table(:jgjx_zzjh) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ccu_rate, :float
      add :ricu_rate, :float
      add :sicu_rate, :float
      add :nicu_rate, :float
      add :picu_rate, :float
      add :other_rate, :float
      timestamps()
    end
  end
end
