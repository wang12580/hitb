defmodule Hitb.Library.Repo.Migrations.CreateIcd10 do
  use Ecto.Migration

  def change do
    create table(:icd10) do
      add :code, :string
      add :codes, {:array, :string}
      add :name, :string
      add :icdcc, :string
      add :icdc, :string
      add :icdc_az, :string
      add :adrg, {:array, :string}
      add :drg, {:array, :string}
      add :cc, :boolean, default: false
      add :nocc_1, {:array, :string}
      add :nocc_a, {:array, :string}
      add :nocc_aa, {:array, :string}
      add :year, :string
      add :mcc, :boolean, default: false
      timestamps()
    end

  end
end
