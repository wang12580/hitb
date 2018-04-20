defmodule Hospitals.Repo.Migrations.CreateYlzlSzfxsj do
  use Ecto.Migration

  def change do
    create table(:ylzl_szfxsj) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ssywss_rate, :float
      add :ssywqg_rate, :float
      add :ssywzc_rate, :float
      add :ssywck_rate, :float
      add :ssywcx_rate, :float
      add :ssylyw_rate, :float
      add :sswjsb_rate, :float
      add :ssczbd_rate, :float
      timestamps()
    end
  end
end
