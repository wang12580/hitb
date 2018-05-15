defmodule ServerWeb.DepartmentController do
  use ServerWeb, :controller

  alias ServerWeb.SchemaHospitals
  alias Server.Department
  plug ServerWeb.Access

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    [class_list, result] = SchemaHospitals.list_department()
    # render(conn, "index.json", department: department)
    json conn, %{class_list: class_list, result: result}
  end

  def create(conn, %{"department" => department_params}) do
    with {:ok, %Department{} = department} <- SchemaHospitals.create_department(department_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", department_path(conn, :show, department))
      |> render("show.json", department: department)
    end
  end

  def show(conn, %{"id" => id}) do
    # id = 1\
    department = Repo.get!(Server.Department, id)
    # department = SchemaHospitals.get_department!(id)
    # json conn, %{department: department}
    render(conn, "show.json", department: department)
  end

  def update(conn, %{"id" => id, "department" => department_params}) do
    department = SchemaHospitals.get_department!(id)

    with {:ok, %Department{} = department} <- SchemaHospitals.update_department(department, department_params) do
      render(conn, "show.json", department: department)
    end
  end

  def delete(conn, %{"id" => id}) do
    department = SchemaHospitals.get_department!(id)
    with {:ok, %Department{}} <- SchemaHospitals.delete_department(department) do
      send_resp(conn, :no_content, "")
    end
  end
end
