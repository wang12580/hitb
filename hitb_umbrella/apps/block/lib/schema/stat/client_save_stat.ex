defmodule Block.Stat.ClientSaveStat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Block.Stat.ClientSaveStat


  schema "client_save_stat" do
    field :username, :string #创建用户
    field :filename, :string #文件名
    field :data, :string #数据
    field :previous_hash, :string
    field :hash, :string
    timestamps()
  end

  @doc false
  def changeset(%ClientSaveStat{} = client_save_stat, attrs) do
    client_save_stat
    |> cast(attrs, [:username, :filename, :data, :previous_hash, :hash])
    |> validate_required([:username, :filename, :data, :previous_hash, :hash])
  end
end
