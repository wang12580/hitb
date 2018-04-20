defmodule Hospitals.Repo.Migrations.CreateZdfhl do
  use Ecto.Migration

  def change do
    create table(:zdfhl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rycyfh_num, :integer
      add :rycyfh_rate, :float
      add :zdblfh_num, :integer
      add :zdblfh_rate, :float
      add :ryssfh_num, :integer
      add :ryssfh_rate, :float
      timestamps()
    end
  end
end
