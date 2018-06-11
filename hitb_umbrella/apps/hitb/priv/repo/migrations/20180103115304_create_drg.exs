defmodule Hitb.Library.Repo.Migrations.CreateDrg do
  use Ecto.Migration

  def change do
    create table(:drg) do
      add :code, :string
      add :name, :string
      add :mdc, :string
      add :adrg, :string
      add :age, {:array, :string}
      # add :ltage, :integer
      add :sf0108, {:array, :string}
      add :mcc, :boolean, default: false
      add :cc, :boolean, default: false
      add :diags_code, {:array, :string}
      add :day, {:array, :string}
      add :year, :string
      timestamps()
    end

  end
end
