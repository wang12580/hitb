defmodule LibraryWeb.ChineseMedicine do
  use LibraryWeb, :view
  alias LibraryWeb.ChineseMedicineView

  def render("index.json", %{chinese_medicine: chinese_medicine}) do
    %{data: render_many(chinese_medicine, ChineseMedicinePatentView, "chinese_medicine.json")}
  end
  def render("show.json", %{chinese_medicine: chinese_medicine}) do
    %{data: render_one(chinese_medicine, ChineseMedicineView, "chinese_medicine.json")}
  end

  def render("chinese_medicine.json", %{chinese_medicine: chinese_medicine}) do
    %{
      code: chinese_medicine.code, #药品分类代码
      name: chinese_medicine.name, #药品类型
      name_1: chinese_medicine.name_1, #药品分类
      sexual_taste: chinese_medicine.sexual_taste, #药品名称
      toxicity: chinese_medicine.toxicity, #名称
      meridian: chinese_medicine.meridian, #其他名称
      effect: chinese_medicine.effect, #其他规格
      indication: chinese_medicine.indication, #限门诊或住院使用
      consumption: chinese_medicine.consumption, #限医疗机构等级
      need_attention: chinese_medicine.need_attention, #人员限制
      type: chinese_medicine.type, #其他限制
      }
  end
end
