defmodule Block.Repo.Migrations.CreateShare do
  use Ecto.Migration

  def change do
    create table(:share) do
      add :file_name,      :string
      add :username,       :string
      add :datetime,       :string
      timestamps()
    end
  end

end
