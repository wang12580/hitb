defmodule Hospitals.Repo.Migrations.CreateJgjxZgfx do
  use Ecto.Migration

  def change do
    create table(:jgjx_zgfx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :zgfx_age, :float
      add :zgysj_num, :integer
      add :zgwsj_num, :integer
      add :zgfx_num, :integer
      add :zgfxsw_num, :integer
      add :zgfxsw_rate, :float
      timestamps()
    end
  end
end
