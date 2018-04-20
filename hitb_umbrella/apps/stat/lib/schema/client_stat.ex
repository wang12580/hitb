defmodule Stat.ClientStat do
  use Ecto.Schema
  import Ecto.Changeset
  alias Stat.ClientStat


  schema "client_stat" do
    field :username, :string #创建用户
    field :filename, :string #文件名
    field :data, :string #数据
    timestamps()
  end

  @doc false
  def changeset(%ClientStat{} = client_stat, attrs) do
    client_stat
    |> cast(attrs, [:username, :filename, :data])
    |> validate_required([:username, :filename, :data])
  end
end
