defmodule Block.Repo.Migrations.CreateBlockList do
  use Ecto.Migration

  def change do
    create table(:block_list) do
      add :previous_hash,   :string
      add :timestamp,       :integer
      add :data,            :string
      add :hash,            :string
      add :generateAdress,  :string
      timestamps()
    end
  end

end
