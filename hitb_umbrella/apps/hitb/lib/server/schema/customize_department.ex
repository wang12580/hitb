defmodule Hitb.Server.CustomizeDepartment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hitb.Server.CustomizeDepartment

  #自定义科室
  schema "customize_department" do
    field :org, :string #所在机构
    field :c_user, :string #创建用户
    field :cherf_department, :string #科室主任
    field :class, :string #所属科室类
    field :department, :string #所属科室
    field :is_imp, :boolean, default: false #是否重点
    field :is_spe, :boolean, default: false #是否特色
    field :professor, :string #副主任
    field :wt_code, :string #内部科室编码
    field :wt_name, :string #内部科室名称
    field :is_ban, :boolean, default: false #是否停用

    timestamps()
  end

  @doc false
  def changeset(%CustomizeDepartment{} = customize_department, attrs) do
    customize_department
    |> cast(attrs, [:wt_name, :wt_code, :class, :department, :cherf_department, :professor, :is_spe, :is_imp, :is_ban, :org, :c_user])
    |> validate_required([:wt_code, :class, :department, :cherf_department, :professor, :is_spe, :is_imp, :is_ban, :org, :c_user])
  end
end
