defmodule Hospitals.Repo.Migrations.CreateJgjxZdfx do
  use Ecto.Migration

  def change do
    create table(:jgjx_zdfx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :zdfx_age, :float
      add :zdysj_num, :integer
      add :zdwsj_num, :integer
      add :zdfx_num, :integer
      add :zdfxsw_num, :integer
      add :zdfxsw_rate, :float
      timestamps()
    end
  end
end
