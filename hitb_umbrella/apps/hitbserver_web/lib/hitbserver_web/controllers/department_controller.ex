defmodule HitbserverWeb.DepartmentController do
  use HitbserverWeb, :controller
  alias Server.DepartmentService
  alias Hitb.Server.Department
  plug HitbserverWeb.Access

  action_fallback HitbserverWeb.FallbackController

  def index(conn, _params) do
    [class_list, result] = DepartmentService.list_department()
    json conn, %{class_list: class_list, result: result}
  end

  def create(conn, %{"department" => department_params}) do
    with {:ok, %Department{} = department} <- DepartmentService.create_department(department_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", department_path(conn, :show, department))
      |> render("show.json", department: department)
    end
  end

  def show(conn, %{"id" => id}) do
    department = DepartmentService.get_department!(id)
    render(conn, "show.json", department: department)
  end

  def update(conn, %{"id" => id, "department" => department_params}) do
    with {:ok, %Department{} = department} <- DepartmentService.update_department(id, department_params) do
      render(conn, "show.json", department: department)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Department{}} <- DepartmentService.delete_department(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
