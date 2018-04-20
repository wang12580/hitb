defmodule Hospitals.Repo.Migrations.CreateJgjxYljc do
  use Ecto.Migration

  def change do
    create table(:jgjx_yljc) do
      add :org, :string
      add :time, :string
      add :drg, :string
      add :drg_type, :string
      add :org_type, :string
      add :time_type, :string
      add :stat_type, :string
      add :ylsy_num, :integer
      add :zl_num, :integer
      add :zl_rate, :float
      add :jc_num, :integer
      add :jc_rate, :float
      add :js_num, :integer
      add :js_rate, :float
      timestamps()
    end
  end
end
