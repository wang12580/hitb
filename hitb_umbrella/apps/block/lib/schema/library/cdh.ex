defmodule Block.Library.Cdh do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Library.Cdh


  schema "cdh" do
    field :key, :string
    field :value, :string
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  @doc false
  def changeset(%Cdh{} = cdh, attrs) do
    cdh
    |> cast(attrs, [:key, :value, :previous_hash, :hash])
    |> validate_required([:key, :value, :previous_hash, :hash])
  end
end
