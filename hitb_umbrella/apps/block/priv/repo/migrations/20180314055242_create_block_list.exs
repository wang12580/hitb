defmodule Block.Repo.Migrations.CreateBlockList do
  use Ecto.Migration

  def change do
    create table(:block_list) do
      add :index,   :integer
      add :previous_hash,   :string
      add :timestamp,       :integer
      add :data,            :string
      add :hash,            :string
      add :generateAdress,  :string
      timestamps()
    end
    create unique_index(:block_list, [:index])
  end

end
