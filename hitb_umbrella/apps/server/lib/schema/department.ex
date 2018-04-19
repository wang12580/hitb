defmodule Server.Department do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Department


  schema "department" do
    field :class_code, :string #内部科室编码
    field :class_name, :string #所属专科名称
    field :department_code, :string #科室编码
    field :department_name, :string #科室名称
    timestamps()
  end

  @doc false
  def changeset(%Department{} = drpartment, attrs) do
    drpartment
    |> cast(attrs, [:class_code, :class_name, :department_code, :department_name])
    |> validate_required([:class_code, :class_name, :department_code, :department_name])
  end
end
