defmodule Server.UploadService do
  alias Hitb.FileService
  alias Hitb.Repo
  alias Hitb.Library.Wt4
  alias Hitb.Server.Org

  def wt4_upload(conn) do
    file_path = System.user_home() <> "/wt4/"
    %{:path => file_path, :file_name => file_name, :file_size => file_size} = FileService.upload_file(file_path, conn.params["file"])
    Hitb.ets_insert(:json, :file_info, %{file_path: file_path, file_name: file_name, file_size: file_size})
    %{file_path: file_path, file_name: file_name, file_size: file_size}
  end
  #
  # def province()do
  #   %{province: Hitb.Province.province(), city: Hitb.Province.city(), county: Hitb.Province.county()}
  # end
  #
  # def wt4_department_list(org) do
  #   #已经设置的科室
  #   customize_department = Repo.all(from p in CustomizeDepartment, where: p.org == ^org, select: p.wt_code)
  #   #全部科室
  #   department = Library.Repo.all(from p in Library.Wt4, where: p.org == ^org, select: p.department, group_by: [p.department], order_by: [asc: p.department])
  #   #未设置科室
  #   department = department -- customize_department
  #   Enum.map(department, fn x -> %{code: x} end)
  # end
  #
  def wt4_insert() do
    json = Hitb.ets_get(:json, :json)
    keys = Map.keys(hd(json))
    org_name =
      cond do
        # keys == nil -> ""
        keys == [] -> ""
        "org" in keys -> hd(json)["org"]
        "org_name" in keys -> hd(json)["org_name"]
        true -> ""
      end
    org = Repo.get_by(Org, name: org_name)
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
          %Wt4{}
          |> Wt4.changeset(x)
          |> Repo.insert
        end
      end)
    length(result)
  end

end
