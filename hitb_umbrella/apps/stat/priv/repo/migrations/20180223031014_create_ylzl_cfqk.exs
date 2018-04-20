defmodule Hospitals.Repo.Migrations.CreateYlzlCfqk do
  use Ecto.Migration

  def change do
    create table(:ylzl_cfqk) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :is_inhosp31, :integer
      add :inhosp_rate, :float
      add :num_num1, :integer
      add :num_rate1, :float
      add :num_num2, :integer
      add :num_rate2, :float
      add :num_num3, :integer
      add :num_rate3, :float
      timestamps()
    end
  end
end
