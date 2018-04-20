defmodule ServerWeb.CustomizeDepartmentView do
  use ServerWeb, :view

  def render("index.json", %{customize_department: customize_department, page_num: page_num, page_list: page_list}) do
    %{data: render_many(customize_department, ServerWeb.CustomizeDepartmentView, "customize_department.json"), page_num: page_num, page_list: page_list}
  end

  def render("show.json", %{customize_department: customize_department, success: success}) do
    %{data: render_one(customize_department, ServerWeb.CustomizeDepartmentView, "customize_department.json"), success: success}
  end

  def render("customize_department.json", %{customize_department: customize_department}) do
    %{id: customize_department.id,
      cherf_department: customize_department.cherf_department,
      class: customize_department.class,
      department: customize_department.department,
      is_imp: customize_department.is_imp,
      is_spe: customize_department.is_spe,
      professor: customize_department.professor,
      wt_code: customize_department.wt_code,
      wt_name: customize_department.wt_name,
      org: customize_department.org,
      is_ban: customize_department.is_ban}
  end
end
