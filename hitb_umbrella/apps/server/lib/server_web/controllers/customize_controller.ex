defmodule ServerWeb.CustomizeDepartmentController do
  use ServerWeb, :controller
  import Ecto.Query, warn: false
  plug ServerWeb.Access
  alias ServerWeb.SchemaHospitals
  alias Server.CustomizeDepartment

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    %{"name" => name, "page" => page} = Map.merge(%{"name" => "", "page" => "1"}, conn.params)
    skip = Hitbserver.Page.skip(page, 15)
    {count, result} = SchemaHospitals.list_customize(name, skip, 15)
    {page_num, page_list, _} = Hitbserver.Page.page_list(page, count, 15)
    render(conn, "index.json", %{customize_department: result, page_num: page_num, page_list: page_list})
  end

  def create(conn, %{"customize_department" => customize_params}) do
    user = get_session(conn, :user)
    user = unless(user)do %{username: customize_params["c_user"]} else user end
    customize_params = Map.merge(customize_params, %{"c_user" => user.username})
    case SchemaHospitals.create_customize_department(customize_params) do
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
    customize_department = Repo.get!(CustomizeDepartment, id)
    render(conn, "show.json", customize_department: customize_department, success: true)
  end

  def update(conn, %{"id" => id, "customize_department" => params}) do
    db_a = SchemaHospitals.get_customize_department!(id)
    case SchemaHospitals.update_customize_department(db_a, params) do
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
    IO.inspect id
    customize_department = SchemaHospitals.get_customize_department!(id)
    with {:ok, %CustomizeDepartment{}} <- SchemaHospitals.delete_customize_department(customize_department) do
      # user = get_session(conn, :user)
      # record = %{type: "科室管理", mode: "删除", username: user.username, old_value: customize_department.wt_code <> ", " <> customize_department.wt_name}
      # SchemaHospitals.create_record(record)
      send_resp(conn, :no_content, "")
    end
  end

  # defp mycase(val) do
  #   case to_string(val) do
  #     "true" -> "是"
  #     "false" -> "否"
  #     _ -> val
  #   end
  # end
end
