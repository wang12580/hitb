defmodule Block.Edit.CdaFile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Edit.CdaFile


  schema "cda_file" do
    field :username, :string
    field :filename, :string
    field :hash, :string
    field :previous_hash, :string
    timestamps()
  end

  @doc false
  def changeset(%CdaFile{} = cda_file, attrs) do
    cda_file
    |> cast(attrs, [:username, :filename, :hash, :previous_hash])
    |> validate_required([:username, :filename, :hash, :previous_hash])
  end
end
