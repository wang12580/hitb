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
    %{:path => file_path, :file_name => file_name, :file_size => file_size} = Hitbserver.File.upload_file(file_path, conn.params["file"])
    Hitbserver.ets_insert(:json, :file_info, %{file_path: file_path, file_name: file_name, file_size: file_size})
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
  def wt4_insert(conn, _params) do
    json = Hitbserver.ets_get(:json, :json)
    keys = Map.keys(hd(json))
    org_name =
      cond do
        keys == nil -> ""
        keys == [] -> ""
        "org" in keys -> hd(json)["org"]
        "org_name" in keys -> hd(json)["org_name"]
        true -> ""
      end
    org = Repo.get_by(Server.Org, name: org_name)
    org =
      case org do
          nil -> %{stat_org_name: "未知", code: "未知"}
          _ -> org
      end
    stat_org_name = "医院" <> to_string(org.stat_org_name)
    result = Enum.map(json, fn x ->
        if(x != [])do
          x = Map.merge(x, %{"stat_org_name" => stat_org_name, "org_code" => org.code})
          # IO.inspect Wt4.changeset(%Wt4{}, x)
          %Library.Wt4{}
          |> Library.Wt4.changeset(x)
          |> Library.Repo.insert
        end
      end)
    json conn, %{result: length(result)}
  end
end
