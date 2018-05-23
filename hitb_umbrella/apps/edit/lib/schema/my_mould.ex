defmodule Edit.MyMould do
  use Ecto.Schema
  import Ecto.Changeset
  alias Edit.MyMould


  schema "my_mould" do
    field :content, :string
    field :name, :string
    field :username, :string
    field :is_change, :boolean, default: false
    field :is_show, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(%MyMould{} = my_mould, attrs) do
    a = cast(my_mould, attrs, [:username, :name, :content, :is_change, :is_show]) |> validate_required([:username, :name, :content, :is_change, :is_show])
    IO.inspect a
    my_mould
    |> cast(attrs, [:username, :name, :content, :is_change, :is_show])
    |> validate_required([:username, :name, :content, :is_change, :is_show])
  end
end
