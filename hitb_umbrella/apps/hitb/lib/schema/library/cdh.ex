defmodule Hitb.Library.Cdh do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Library.Cdh


  schema "cdh" do
    field :key, :string
    field :value, :string
    field :username, :string
    timestamps()
  end

  @doc false
  def changeset(%Cdh{} = cdh, attrs) do
    cdh
    |> cast(attrs, [:key, :value, :username])
    |> validate_required([:key])
  end
end
