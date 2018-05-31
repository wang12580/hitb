defmodule Block.Share do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Share


  schema "share" do
    field :file_name,      :string
    field :username,       :string
    field :datetime,       :string
    timestamps()
  end

  @doc false
  def changeset(%Share{} = share, attrs) do
    share
    |> cast(attrs, [:file_name, :username, :datetime])
    |> validate_required([:file_name, :username, :datetime])
  end
end
