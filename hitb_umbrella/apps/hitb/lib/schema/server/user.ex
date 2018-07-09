defmodule Hitb.Server.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Server.User


  schema "user" do
    field :age, :integer #年龄
    field :email, :string #电子邮箱
    field :hashpw, :string #密码
    field :name, :string #姓名
    field :org, :string #机构
    field :tel, :string #电话
    field :username, :string #用户名
    field :type, :integer #用户类型 1-管理员 2-普通用户
    field :block_address, :string #区块链hash
    field :key, {:array, :string}
    field :is_show, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :hashpw, :org, :age, :email, :tel, :name, :type, :key, :is_show, :block_address])
    |> validate_required([:username, :hashpw, :org, :age, :email, :tel, :name, :type, :is_show])
    |> unique_constraint(:username)
  end
end
