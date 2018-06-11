defmodule Hitb.Library.Repo.Migrations.CreateIcd9 do
  use Ecto.Migration

  def change do
    create table(:icd9) do
      add :code, :string
      add :codes, {:array, :string}
      add :name, :string
      add :icdcc, :string
      add :icdc, :string
      add :adrg, {:array, :string}
      add :drg, {:array, :string}
      add :p_type, :integer
      add :is_qy, :boolean, default: false
      add :year, :string
      timestamps()
    end

  end
end
