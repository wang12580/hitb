defmodule Hitb.Server.Org do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Server.Org


  schema "org" do
    field :county, :string #县
    field :city, :string #市
    field :code, :string #机构代码
    field :name, :string #机构名称
    field :email, :string #联系人邮箱
    field :is_show, :boolean, default: false #在wt4中是否显示
    field :is_ban, :boolean, default: false #是否弃用
    field :level, :string #机构等级
    field :person_name, :string #联系人
    field :province, :string #身份
    field :tel, :string #电话
    field :type, :string #机构类别
    field :stat_org_name, :integer #计算机构补充

    timestamps()
  end

  @doc false
  def changeset(%Org{} = org, attrs) do
    org
    |> cast(attrs, [:code, :name, :level, :type, :province, :city, :person_name, :tel, :email, :is_show, :is_ban, :county, :stat_org_name])
    |> validate_required([:code, :name, :level, :type, :province, :city, :person_name, :tel, :email, :is_show, :is_ban, :county, :stat_org_name])
    |> unique_constraint(:code)
  end
end
