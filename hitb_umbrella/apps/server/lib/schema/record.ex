defmodule Server.Record do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Record


  schema "record" do
    field :mode, :string #操作
    field :type, :string #所在页面
    field :username, :string #帐号
    field :old_value, :string #旧值
    field :value, :string #新值

    timestamps()
  end

  @doc false
  def changeset(%Record{} = record, attrs) do
    record
    |> cast(attrs, [:type, :mode, :value, :username, :old_value])
    |> validate_required([:type, :mode, :username])
  end
end
