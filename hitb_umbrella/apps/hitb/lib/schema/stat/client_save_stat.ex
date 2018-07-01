defmodule Hitb.Stat.ClientSaveStat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Stat.ClientSaveStat


  schema "client_save_stat" do
    field :username, :string #创建用户
    field :filename, :string #文件名
    field :data, :string #数据
    timestamps()
  end

  @doc false
  def changeset(%ClientSaveStat{} = client_save_stat, attrs) do
    client_save_stat
    |> cast(attrs, [:username, :filename, :data])
    |> validate_required([:username, :filename, :data])
  end
end
