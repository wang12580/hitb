defmodule Hospitals.Repo.Migrations.CreateJgjxYlzl do
  use Ecto.Migration

  def change do
    create table(:jgjx_ylzl) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :wlzl_rate, :float
      add :jrzl_rate, :float
      add :tszl_rate, :float
      add :kfzl_rate, :float
      add :zyzl_rate, :float
      add :ybzl_rate, :float
      add :jszl_rate, :float
      timestamps()
    end
  end
end
