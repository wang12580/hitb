defmodule Hospitals.Repo.Migrations.CreateTifxZlm0 do
  use Ecto.Migration

  def change do
    create table(:tjfx_zlm0) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ml_num, :integer
      add :ml_rate, :float
      add :mo_num, :integer
      add :mo_rate, :float
      add :wfpgyc_num, :integer
      add :wfpgyc_rate, :float
      timestamps()
    end
  end
end
