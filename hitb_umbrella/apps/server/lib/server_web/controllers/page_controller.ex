defmodule ServerWeb.PageController do
  use ServerWeb, :controller
  plug ServerWeb.Access
  alias Server.CustomizeDepartment
  # alias Server.Wt4

  def index(conn, _params) do
    render conn, "index.html"
  end

  def wt4_upload(conn, _params)do
    file_path = System.user_home() <> "/wt4/"
    %{:path => file_path, file_name: file_name, file_size: file_size} = Hitbserver.File.upload_file(file_path, conn.params["file"])
    json conn, %{file_path: file_path, file_name: file_name, file_size: file_size}
  end

  def connect(conn, _params) do
    json conn, %{success: true}
  end

  def province(conn, _params)do
    json conn, %{province: Hitbserver.Province.province(), city: Hitbserver.Province.city(), county: Hitbserver.Province.county()}
  end
  def wt4_department_list(conn, %{"org" => org}) do
    #已经设置的科室
    customize_department = Repo.all(from p in CustomizeDepartment, where: p.org == ^org, select: p.wt_code)
    #全部科室
    department = Library.Repo.all(from p in Library.Wt4, where: p.org == ^org, select: p.department, group_by: [p.department], order_by: [asc: p.department])
    #未设置科室
    department = department -- customize_department
    department = Enum.map(department, fn x -> %{code: x} end)
    json conn, %{department: department}
  end
end
