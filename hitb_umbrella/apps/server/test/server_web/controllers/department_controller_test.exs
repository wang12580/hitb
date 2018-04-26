defmodule ServerWeb.DepartmentControllerTest do
  use ServerWeb.ConnCase

  @valid_attrs %{class_code: "0000", class_name: "123456", department_code: "77", department_name: "77"}

  test "POST /create", %{conn: conn} do
    conn = post conn, department_path(conn, :create), department: @valid_attrs
    assert json_response(conn, 201)["data"] != nil
  end
  test "POST /show", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.Department{}, @valid_attrs))
    department = Server.Repo.get_by(Server.Department, class_code: @valid_attrs.class_code)
    conn = get conn, department_path(conn, :show, department.id)
    assert json_response(conn, 200)["data"] != nil
  end
  test "POST /update", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.Department{}, @valid_attrs))
    department = Server.Repo.get_by(Server.Department, class_code: @valid_attrs.class_code)
    conn = get conn, department_path(conn, :update, department.id, @valid_attrs)
    assert json_response(conn, 200)["data"] != nil
  end
  test "POST /delete", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.Department{}, @valid_attrs))
    department = Server.Repo.get_by(Server.Department, class_code: @valid_attrs.class_code)
    conn = get conn, department_path(conn, :delete, department.id)
    assert json_response(conn, 200)["data"] != nil
  end
end
