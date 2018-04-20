defmodule Hospitals.Repo.Migrations.CreateTifxRhyin do
  use Ecto.Migration

  def change do
    create table(:tjfx_rhyin) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :rhyacc_rate, :float
      add :rhybcc_rate, :float
      add :rhyabcc_rate, :float
      add :rhy0cc_rate, :float
      add :rhya_cc, :integer
      add :rhyb_cc, :integer
      add :rhyab_cc, :integer
      add :rhyo_cc, :integer
      timestamps()
    end
  end
end
