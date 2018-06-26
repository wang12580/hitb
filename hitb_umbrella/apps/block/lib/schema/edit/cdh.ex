defmodule Block.Edit.Cdh do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Edit.Cdh


  schema "cdh" do
    field :content, :string
    field :name, :string
    field :type, :string
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  @doc false
  def changeset(%Cdh{} = cdh, attrs) do
    cdh
    |> cast(attrs, [:content, :name, :type, :previous_hash, :hash])
    |> validate_required([:content, :name, :type, :previous_hash, :hash])
  end
end
