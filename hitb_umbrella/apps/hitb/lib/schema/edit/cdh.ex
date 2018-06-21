defmodule Hitb.Edit.Cdh do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Edit.Cdh


  schema "cdh" do
    field :content, :string
    field :name, :string
    field :type, :string
    timestamps()
  end

  @doc false
  def changeset(%Cdh{} = cdh, attrs) do
    cdh
    |> cast(attrs, [:content, :name, :type])
    |> validate_required([:content, :name, :type])
  end
end
