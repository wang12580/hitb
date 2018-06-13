defmodule Hitb.Library.Repo.Migrations.Patient do
    use Ecto.Migration

    def change do
      create table(:patient) do
        add :name, :string #姓名
        add :gender, :string #性别
        add :age, :string #年龄
        add :nationality, :string #民族
        add :marriage, :string #婚姻
        add :native_place, :string #籍贯
        add :occupation, :string #职业
        add :username, :string #用户名
        add :patient_id, {:array, :string}
        timestamps()
      end

    end
  end