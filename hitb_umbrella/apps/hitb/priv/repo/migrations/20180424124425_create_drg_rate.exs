defmodule Hitb.Library.Repo.Migrations.CreateDrgRate do
  use Ecto.Migration

  def change do
    create table(:drg_rate) do
      add :drg, :string
      add :name, :string
      add :rate, :float
      add :type, :string
      timestamps()
    end

  end
end
