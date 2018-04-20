defmodule Hospitals.Repo.Migrations.CreateCwzbBsnc do
  use Ecto.Migration

  def change do
    create table(:cwzb_bsnc) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :bsxnh_rate, :float
      add :bsxnhzf_rate, :float
      add :bsxnhyl_rate, :float
      add :bsxnhyj_rate, :float
      add :bsxnhypj_rate, :float
      add :bsxnhhl_rate, :float
      add :bsxnhgl_rate, :float
      timestamps()
    end
  end
end
