defmodule Stat.ClientSaveService do
  import Ecto.Query
  alias Hitb.Repo, as: HitbRepo
  alias Block.Repo, as: BlockRepo
  alias Stat.Query
  alias Stat.Key
  alias Stat.Convert
  alias Stat.StatService
  alias Hitb.Stat.ClientSaveStat, as: HitbClinetStat
  alias Hitb.Stat.StatFile, as: HitbStatFile
  alias Hitb.Server.User, as: HitbUser
  alias Block.Stat.ClientSaveStat, as: BlockClinetStat
  alias Hitb.Stat.StatFile, as: HitbStatFile
  alias Block.Stat.StatFile, as: BlockStatFile
  alias Hitb.Time

  def stat_create(data, username) do
    filename = Time.stimehour_number <> "对比分析.csv"
    case HitbRepo.get_by(HitbClinetStat, filename: filename, username: username) do
      nil ->
        %HitbClinetStat{}
        |> HitbClinetStat.changeset(%{data: data, username: username, filename: filename})
        |> HitbRepo.insert
        %{success: true, filename: filename}
      _ ->
        %{success: false, filename: filename}
    end
  end

  def stat_client(page, page_type, type, tool_type, org, time, drg, order, order_type, username, rows, server_type) do
    [repo, clinet_stat, stat_file] = if(server_type == "server")do [HitbRepo, HitbClinetStat, HitbStatFile] else [BlockRepo, BlockClinetStat, BlockStatFile] end
    files = repo.all(from p in clinet_stat, where: p.username == ^username, select: p.filename)|>List.flatten|>Enum.uniq
    if(page_type <> ".csv" in files)do
      stat = repo.get_by(clinet_stat, filename: page_type <> ".csv", username: username)
      stat = Poison.decode!(stat.data)
      header = Enum.at(stat, 0)
      #求病历总数
      num_index = Enum.find_index(header, fn(x) -> x == "病历数" or x == "病例数" end)
      [num, org_num, time_num, drg_num] =
        if(num_index)do
          num = stat|>Enum.map(fn x -> Enum.at(x, num_index) end)|>Enum.reject(fn x -> not is_integer(x) end)|>Enum.sum
          #求机构总数
          index = Enum.find_index(header, fn(x) -> x == "机构" end)
          org_num = stat|>List.delete_at(0)|>Enum.map(fn x -> Enum.at(x, index) end)|>:lists.usort|>length
          #求时间总数
          index = Enum.find_index(header, fn(x) -> x == "时间" end)
          time_num = stat|>List.delete_at(0)|>Enum.map(fn x -> Enum.at(x, index) end)|>:lists.usort|>length
          #求病种数
          index = Enum.find_index(header, fn(x) -> x == "病种" end)
          drg_num = if("病种" in header)do stat|>List.delete_at(0)|>Enum.map(fn x -> Enum.at(x, index) end)|>:lists.usort|>length else 0 end
          [num, org_num, time_num, drg_num]
        else
          [length(stat) - 1, 0, 0, 0]
        end
      %{stat: stat, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num, server_type: server_type}
    else
      stat_file =
        case page_type do
          "defind__" -> %{page_type: "defined"}
          _ -> repo.get_by(stat_file, file_name: "#{page_type}.csv")
        end
      page_type =
        case stat_file do
          nil -> "base"
          _ -> stat_file.page_type
        end
      rows = to_string(rows)|>String.to_integer
      #获取分析结果
      [stat, _, tool, page_list, _, count, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows, "stat", server_type)
      stat = [key, cnkey] ++ Convert.map2list(stat, key)
      #存储在自定义之前最后一次url
      Hitb.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org, time])
      # stat = Stat.Rand.rand(stat)
      stat = stat|>List.delete_at(0)
      #多种list一次返回
      list =
        %{org: ["全部"] ++ Query.list("org", org, time, server_type),
        department: ["全部"] ++ Query.list("department", org, time, server_type),
        year_time: ["全部"] ++ Query.list("year_time", org, time, server_type),
        half_year: ["全部"] ++ Query.list("half_year", org, time, server_type),
        season_time: ["全部"] ++ Query.list("season_time", org, time, server_type),
        month_time: ["全部"] ++ Query.list("month_time", org, time, server_type),
        mdc: ["-", "全部"] ++ Query.list("mdc", org, time, server_type),
        adrg: ["-", "全部"] ++ Query.list("adrg", org, time, server_type),
        drg: ["-", "全部"] ++ Query.list("drg", org, time, server_type)}
      #计算客户端提示
      [num, org_num, time_num, drg_num] = [count, length(list.org), length(list.year_time), length(list.drg)]
      %{stat: stat, count: count, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num, page: page, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type, server_type: server_type, type: type}
    end
  end

  def stat_file(name, _username, server_type) do
    [repo, tab] =
      case server_type do
        "server" -> [HitbRepo, HitbStatFile]
        "block" -> [BlockRepo, BlockStatFile]
      end
    first_menu = repo.all(from p in tab, select: fragment("array_agg(distinct ?)", p.first_menu))|>List.flatten
    second_menu = repo.all(from p in tab, select: fragment("array_agg(distinct ?)", p.second_menu))|>List.flatten
    # file_name = repo.all(from p in tab, select: fragment("array_agg(distinct ?)", p.file_name))|>List.flatten
    [data, menu] =
      cond do
        name == "" ->
          [first_menu, "一级菜单"]
        name in first_menu ->
          data = repo.all(from p in tab, where: p.first_menu == ^name, select: fragment("array_agg(distinct ?)", p.second_menu))|>List.flatten
          [data, "二级菜单"]
        name in second_menu ->
          data = repo.all(from p in tab, where: p.second_menu == ^name, select: fragment("array_agg(distinct ?)", p.file_name))|>List.flatten
          [data, "三级菜单"]
      end
    %{data: data, menu: menu}
  end

  def stat_info(page, type, tool_type, drg, order, order_type, page_type, org, time, username, server_type) do
    [repo, stat_file] = if(server_type == "server")do [HitbRepo, HitbStatFile] else [BlockRepo, BlockStatFile] end
    stat_file = repo.get_by(stat_file, file_name: "#{page_type}.csv")
    page_type =
      case stat_file do
        nil -> "base"
        _ -> stat_file.page_type
      end
    Hitb.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org, time])
    [stat, _, _, _, _, _, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, 13, "stat", server_type)
    Hitb.ets_insert(:stat_drg, "comx_" <> username, stat)
    stat = [cnkey] ++ Convert.map2list(Query.info(username), key)
    %{stat: stat}
  end

  def clinet_download(page, page_type, type, tool_type, org, time, drg, order, order_type, username) do
    stat_file = HitbRepo.get_by(HitbStatFile, file_name: "#{page_type}.csv")
    page_type =
      case stat_file do
        nil -> "base"
        _ -> stat_file.page_type
      end
    StatService.get_download(page, page_type, type, tool_type, org, time, drg, order, order_type, username)
  end

  def custom(custom, username) do
    key = HitbRepo.get_by( HitbUser, username: username)
    if key do
      custom = String.split(custom, ",")|>Enum.map(fn x -> Key.enkey(x) end)
      # keys = Enum.uniq(Enum.concat(custom, key.key))
      key
      |> HitbUser.changeset(%{username: username, key: custom})
      |> HitbRepo.update()
    end
  end

  def custom_select(username, _) do
    HitbRepo.get_by( HitbUser, username: username)
  end
end
