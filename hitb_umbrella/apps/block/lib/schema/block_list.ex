defmodule Block.BlockList do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.BlockList


  schema "block_list" do
    field :index,          :integer
    field :previous_hash,  :string
    field :timestamp,      :integer
    field :data,           :string
    field :hash,           :string
    field :generateAdress, :string
    timestamps()
  end

  @doc false
  def changeset(%BlockList{} = block_list, attrs) do
    block_list
    |> cast(attrs, [:index, :previous_hash, :timestamp, :data, :hash, :generateAdress])
    |> validate_required([:index, :previous_hash, :timestamp, :data, :hash, :generateAdress])
  end
end
