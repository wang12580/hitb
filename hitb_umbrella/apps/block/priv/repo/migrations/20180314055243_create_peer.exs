defmodule Block.Repo.Migrations.CreatePeer do
  use Ecto.Migration

  def change do
    create table(:peer) do
      add :host,    :string
      add :port,    :string
      add :connect, :boolean, default: false
      timestamps()
    end
  end

end
