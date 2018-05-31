defmodule Block.Server.Repo.Migrations.CreateChatRecord do
  use Ecto.Migration

  def change do
    create table(:chat_record) do
      add :room, :string
      add :date, :string
      add :record_string, :string
      add :record_array, {:array, :string}
      add :previous_hash, :string
      add :hash, :string
      timestamps()
    end
  end
end
