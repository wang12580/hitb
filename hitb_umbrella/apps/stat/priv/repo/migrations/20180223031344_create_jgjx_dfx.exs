defmodule Hospitals.Repo.Migrations.CreateJgjxDfx do
  use Ecto.Migration

  def change do
    create table(:jgjx_dfx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :dfx_age, :float
      add :ysj_num, :integer
      add :wsj_num, :integer
      add :dfx_num, :integer
      add :dfxsw_num, :integer
      add :dfxsw_rate, :float
      timestamps()
    end
  end
end
