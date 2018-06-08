defmodule Hitb.Edit.CdaFile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Edit.CdaFile


  schema "cda_file" do
    field :username, :string
    field :filename, :string
    timestamps()
  end

  @doc false
  def changeset(%CdaFile{} = cda_file, attrs) do
    cda_file
    |> cast(attrs, [:username, :filename])
    |> validate_required([:username, :filename])
  end
end
