defmodule ServerWeb.CustomizeDepartmentControllerTest do
  use ServerWeb.ConnCase

  @valid_attrs %{org: "0000", c_user: "123456", cherf_department: "77", class: "77", is_imp: true,
  is_spe: true, professor: "sss", wt_code: "ssss", wt_name: "sss", is_ban: true }

  test "POST /create", %{conn: conn} do
    conn = post conn, customize_department_path(conn, :create), customize_department: @valid_attrs
    assert json_response(conn, 201)["data"] != nil
  end
  test "POST /show", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.CustomizeDepartment{}, @valid_attrs))
    customizeDepartment = Server.Repo.get_by(Server.CustomizeDepartment, wt_code: @valid_attrs.wt_code)
    conn = get conn, customize_department_path(conn, :show, customizeDepartment.id)
    assert json_response(conn, 200)["data"] != nil
  end
  test "POST /update", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.CustomizeDepartment{}, @valid_attrs))
    customizeDepartment = Server.Repo.get_by(Server.CustomizeDepartment, wt_code: @valid_attrs.wt_code)
    conn = get conn, customize_department_path(conn, :update, customizeDepartment.id, @valid_attrs)
    assert json_response(conn, 200)["data"] != nil
  end
  test "POST /delete", %{conn: conn} do
    Server.Repo.insert!(Map.merge(%Server.CustomizeDepartment{}, @valid_attrs))
    customizeDepartment = Server.Repo.get_by(Server.CustomizeDepartment, wt_code: @valid_attrs.wt_code)
    conn = get conn, customize_department_path(conn, :delete, customizeDepartment.id)
    assert json_response(conn, 200)["data"] != nil
  end
end
