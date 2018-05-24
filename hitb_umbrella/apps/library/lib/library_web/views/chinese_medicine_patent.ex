defmodule LibraryWeb.ChineseMedicinePatent do
  use LibraryWeb, :view
  alias LibraryWeb.ChineseMedicinePatentView

  def render("index.json", %{chinese_medicine_patent: chinese_medicine_patent}) do
    %{data: render_many(chinese_medicine_patent, ChineseMedicinePatentView, "chinese_medicine_patent.json")}
  end
  def render("show.json", %{chinese_medicine_patent: chinese_medicine_patent}) do
    %{data: render_one(chinese_medicine_patent, ChineseMedicinePatentView, "chinese_medicine_patent.json")}
  end

  def render("chinese_medicine_patent.json", %{chinese_medicine_patent: chinese_medicine_patent}) do
    %{
      code: chinese_medicine_patent.code, #药品分类代码
      medicine_type: chinese_medicine_patent.medicine_type, #药品类型
      type: chinese_medicine_patent.type, #药品分类
      medicine_code: chinese_medicine_patent.medicine_code, #药品名称
      name: chinese_medicine_patent.name, #名称
      name_1: chinese_medicine_patent.name_1, #其他名称
      other_spec: chinese_medicine_patent.other_spec, #其他规格
      org_limit: chinese_medicine_patent.org_limit, #限门诊或住院使用
      department_limit: chinese_medicine_patent.department_limit, #限医疗机构等级
      user_limit: chinese_medicine_patent.user_limit, #人员限制
      other_limit: chinese_medicine_patent.other_limit, #其他限制
      }
  end
end
