defmodule HitbserverWeb.CustomizeDepartmentController do
  use HitbserverWeb, :controller
  plug HitbserverWeb.Access
  alias Hitb.Server.CustomizeDepartment
  alias Server.CustomizeDepartmentService

  action_fallback HitbserverWeb.FallbackController

  def index(conn, _params) do
    %{"name" => name, "page" => page} = Map.merge(%{"name" => "", "page" => "1"}, conn.params)
    result = CustomizeDepartmentService.list_customize(page, name, 15)
    render(conn, "index.json", result)
  end

  def create(conn, %{"customize_department" => customize_params}) do
    user = get_session(conn, :user)
    user = unless(user)do %{username: customize_params["c_user"]} else user end
    case CustomizeDepartmentService.create_customize(customize_params, user) do
      {:ok, customize_department} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", customize_department_path(conn, :show, customize_department))
        |> render("show.json", customize_department: customize_department, success: true)
      {:error, customize_department} ->
        customize_department = Map.merge(%CustomizeDepartment{id: -1}, customize_department.changes)
        conn
        |> put_status(:created)
        |> put_resp_header("location", customize_department_path(conn, :show, customize_department))
        |> render("show.json", customize_department: customize_department, success: false)
    end
  end

  def show(conn, %{"id" => id}) do
    customize_department = CustomizeDepartmentService.get_customize!(id)
    render(conn, "show.json", customize_department: customize_department, success: true)
  end

  def update(conn, %{"id" => id, "customize_department" => params}) do
    case CustomizeDepartmentService.update_customize(id, params) do
      {:ok, cdepartment} ->
        conn
        |> put_resp_header("location", customize_department_path(conn, :show, cdepartment))
        |> render("show.json", customize_department: cdepartment, success: true)
      {:error, cdepartment} ->
        cdepartment = Map.merge(%CustomizeDepartment{id: -1}, cdepartment.changes)
        conn
        |> put_resp_header("location", customize_department_path(conn, :show, cdepartment))
        |> render("show.json", customize_department: cdepartment, success: false)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %CustomizeDepartment{}} <- CustomizeDepartmentService.delete_customize(id) do
      # user = get_session(conn, :user)
      # record = %{type: "科室管理", mode: "删除", username: user.username, old_value: customize_department.wt_code <> ", " <> customize_department.wt_name}
      # SchemaHospitals.create_record(record)
      send_resp(conn, :no_content, "")
    end
  end
end
