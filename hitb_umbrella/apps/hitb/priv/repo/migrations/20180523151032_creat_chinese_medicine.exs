defmodule Hitb.Library.Repo.Migrations.ChineseMedicine do
  use Ecto.Migration

  def change do
    create table(:chinese_medicine) do
      add :code, :string #编码
      add :name, :string #名称
      add :name_1, :string #别名
      # add :icd9_aa, {:array, :string}
      add :sexual_taste, :string #性味
      add :toxicity, :string # 毒性
      add :meridian, :string #归经
      add :effect, :string #功效
      add :indication, :string # 适应症
      add :consumption, :string #用量
      add :need_attention, :string #注意事项
      add :type, :string #分类
      timestamps()
    end

  end
end
