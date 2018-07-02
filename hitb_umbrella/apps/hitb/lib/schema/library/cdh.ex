defmodule Hitb.Library.Cdh do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Library.Cdh


  schema "cdh" do
    field :key, :string
    field :value, :string
    timestamps()
  end

  @doc false
  def changeset(%Cdh{} = cdh, attrs) do
    cdh
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
