defmodule ServerWeb.DepartmentView do
  use ServerWeb, :view

  def render("index.json", %{department: department}) do
    %{data: render_many(department, ServerWeb.DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, ServerWeb.DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{id: department.id,
      class_code: department.class_code,
      class_name: department.class_name,
      department_code: department.department_code,
      department_name: department.department_name}
  end
end
