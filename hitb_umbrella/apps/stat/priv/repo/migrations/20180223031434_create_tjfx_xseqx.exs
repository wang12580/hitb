defmodule Hospitals.Repo.Migrations.CreateTifxXseqx do
  use Ecto.Migration

  def change do
    create table(:tjfx_xseqx) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :xhqx_rate, :float
      add :sjqx_rate, :float
      add :hxqx_rate, :float
      add :xyqx_rate, :float
      add :ydqx_rate, :float
      add :nfmqx_rate, :float
      add :mnqx_rate, :float
      add :szqx_rate, :float
      timestamps()
    end
  end
end
