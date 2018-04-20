defmodule Hospitals.Repo.Migrations.CreateTifxRhyin2 do
  use Ecto.Migration

  def change do
    create table(:tjfx_rhyin2) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rhya_num, :integer
      add :rhya_rate, :float
      add :rhyb_num, :integer
      add :rhyb_rate, :float
      add :rhyo_num, :integer
      add :rhyo_rate, :float
      add :rhyab_num, :integer
      add :rhyab_rate, :float
      timestamps()
    end
  end
end
