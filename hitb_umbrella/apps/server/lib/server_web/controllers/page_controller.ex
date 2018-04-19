defmodule ServerWeb.PageController do
  use ServerWeb, :controller
  plug ServerWeb.Access

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
end
