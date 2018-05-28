defmodule Server.DepartmentServiceTest do
  use Hitb.DataCase, async: true
  alias Server.DepartmentService

  @department %{class_code: "room", class_name: "2018", department_code: "sss", department_name: "sss"}

  test "test list_department" do
    assert DepartmentService.list_department() == [[], %{}]
  end

  test "test create_department" do
    {:ok, department} = DepartmentService.create_department(@department)
    assert department.id
  end

  test "test get_department!" do
    {:ok, department} = DepartmentService.create_department(@department)
    assert DepartmentService.get_department!(department.id).class_code == @department.class_code
  end

  test "test update_department" do
    {:ok, department} = DepartmentService.create_department(@department)
    DepartmentService.update_department(department.id, %{class_code: "room2"})
    assert DepartmentService.get_department!(department.id).class_code == "room2"
  end

  test "test delete_department" do
    {:ok, department} = DepartmentService.create_department(@department)
    DepartmentService.delete_department(department.id)
    assert DepartmentService.list_department() == [[], %{}]
  end

end
