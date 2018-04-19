defmodule Edit.Client.Cda do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edit.Client.Cda


  schema "cda" do
    field :content, :string
    field :name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%Cda{} = cda, attrs) do
    cda
    |> cast(attrs, [:username, :name, :content])
    |> validate_required([:username, :name, :content])
  end
end
