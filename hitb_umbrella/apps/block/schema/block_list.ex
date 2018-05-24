defmodule Block.BlockList do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.BlockList


  schema "block_list" do
    filed :previous_hash:  :string
    filed :timestamp       :integer
    filed :data            :string
    filed :hash            :string
    filed :generateAdress  :string
    timestamps()
  end

  @doc false
  def changeset(%BlockList{} = block_list, attrs) do
    block_list
    |> cast(attrs, [:previous_hash, :timestamp, :data, :hash, :generateAdress])
    |> validate_required([:previous_hash, :timestamp, :data, :hash, :generateAdress])
  end
end
