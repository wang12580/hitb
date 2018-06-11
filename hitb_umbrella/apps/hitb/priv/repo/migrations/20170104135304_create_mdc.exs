defmodule Hitb.Library.Repo.Migrations.CreateMdc do
  use Ecto.Migration

  def change do
    create table(:mdc) do
      add :code, :string
      add :name, :string
      add :mdc, :string
      # add :icd9_aa, {:array, :string}
      add :is_p, :boolean, default: false
      add :gender, :string
      add :year, :string
      timestamps()
    end

  end
end
