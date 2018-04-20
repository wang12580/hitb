defmodule Hospitals.Repo.Migrations.CreateJgjxGfx do
  use Ecto.Migration

  def change do
    create table(:jgjx_gfx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :gfx_age, :float
      add :gysj_num, :integer
      add :gwsj_num, :integer
      add :gfx_num, :integer
      add :gfxsw_num, :integer
      add :gfxsw_rate, :float
      timestamps()
    end
  end
end
