defmodule Hospitals.Repo.Migrations.CreateJgjxCw do
  use Ecto.Migration

  def change do
    create table(:jgjx_cw) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :sjkfzc_num, :integer
      add :sjzyzc_num, :integer
      add :cyzzyzc_num, :integer
      add :pjkfbc_num, :integer
      add :bczz_num, :integer
      add :bcgzr_num, :integer
      add :cyzpjzy_num, :integer
      add :bcsy_rate, :float
      timestamps()
    end
  end
end
