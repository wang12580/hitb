defmodule Block.Repo.Migrations.CreateShareRecord do
  use Ecto.Migration

  def change do
    create table(:share_record) do
      add :file_name,      :string
      add :username,       :string
      add :datetime,       :string
      add :type,           :string
      timestamps()
    end
  end

end
