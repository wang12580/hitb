defmodule Stat.ClientService do
  import Ecto.Query
  alias Hitb.Repo
  alias Stat.Query
  alias Hitb.Stat.ClientStat

  def stat_create(data, username) do
    filename = Hitb.Time.stimehour_number <> "对比分析.csv"
    case Repo.get_by(ClientStat, filename: filename, username: username) do
      nil ->
        %ClientStat{}
        |> ClientStat.changeset(%{data: data, username: username, filename: filename})
        |> Repo.insert
        %{success: true, filename: filename}
      _ ->
        %{success: false, filename: filename}
    end
  end

  def stat_client(page, page_type, type, tool_type, org, time, drg, order, order_type, username, rows) do
    files = Repo.all(from p in ClientStat, where: p.username == ^username, select: p.filename)|>List.flatten|>Enum.uniq
    if(page_type <> ".csv" in files)do
      stat = Repo.get_by(ClientStat, filename: page_type <> ".csv", username: username)
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
      %{stat: stat, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num}
    else
      page_type = Stat.page_en(page_type)
      rows = to_string(rows)|>String.to_integer
      #获取分析结果
      [stat, list, tool, page_list, _, count, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows, "stat")
      stat = [key, cnkey] ++ Stat.Convert.map2list(stat, key)
      #存储在自定义之前最后一次url
      Hitb.ets_insert(:stat_drg, "defined_url_" <> username, [page, type, tool_type, drg, order, order_type, page_type, org])
      # stat = Stat.Rand.rand(stat)
      stat = stat|>List.delete_at(0)
      #计算客户端提示
      [clinet_stat, _, _, _, _, _, key, cnkey, _] = Query.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows, "download")
      clinet_stat = [key, cnkey] ++ Stat.Convert.map2list(clinet_stat, key)
      header = Enum.at(clinet_stat, 1)
      clinet_stat = clinet_stat|>List.delete_at(0)|>List.delete_at(0)
      num = clinet_stat|>Enum.map(fn x -> List.last(x) end)|>Enum.sum
      org_num =  clinet_stat|>Enum.map(fn x -> List.first(x) end)|>:lists.usort|>length
      time_num =  clinet_stat|>Enum.map(fn x -> Enum.at(x, 1) end)|>:lists.usort|>length
      drg_num = if("病种" in header)do clinet_stat|>Enum.map(fn x -> Enum.at(x, 2) end)|>:lists.usort|>length else 0 end
      %{stat: stat, count: count, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num, page: page, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type}
    end
  end

  def stat_file(name, username) do
    [data, menu] =
      cond do
        name == "" ->
          [["医疗质量", "机构分析", "机构绩效", "统计分析", "财务指标", "保存的对比分析"], "一级菜单"]
        name in ["医疗质量", "机构分析", "机构绩效", "统计分析", "财务指标", "保存的对比分析"] ->
          case name do
            "医疗质量" -> [["医疗质量_手术质量","医疗质量_负性事件"], "二级菜单"]
            "机构分析" -> [["机构分析_基础分析"], "二级菜单"]
            "机构绩效" -> [["机构绩效_机构工作量","机构绩效_机构效率", "机构绩效_机构绩效"], "二级菜单"]
            "统计分析" -> [["统计分析_病案统计", "统计分析_肿瘤统计"], "二级菜单"]
            "财务指标" -> [["财务指标_机构收入"], "二级菜单"]
            "保存的对比分析" -> [Repo.all(from p in ClientStat, where: p.username == ^username, select: p.filename)|>List.flatten|>Enum.uniq, "二级菜单"]
          end
        name in ["医疗质量_手术质量","医疗质量_负性事件","机构分析_基础分析", "机构绩效_机构工作量","机构绩效_机构效率", "机构绩效_机构绩效","统计分析_病案统计", "统计分析_肿瘤统计","财务指标_机构收入"] ->
          csv =
            case name do
              "医疗质量_手术质量" -> ["医疗质量_手术质量_手术质量分析"]
              "医疗质量_负性事件" -> ["医疗质量_负性事件_压疮", "医疗质量_负性事件_护理", "医疗质量_负性事件_药物", "医疗质量_负性事件_输血"]
              "机构分析_基础分析" -> ["机构分析_基础分析"]
              "机构绩效_机构工作量" -> ["机构绩效_机构工作量_医疗检查工作量", "机构绩效_机构工作量_医疗治疗工作量", "机构绩效_机构工作量_医技工作量", "机构绩效_机构工作量_重症监护室工作量"]
              "机构绩效_机构效率" -> ["机构绩效_机构效率_床位指标"]
              "机构绩效_机构绩效" -> ["机构绩效_机构绩效_低风险组统计", "机构绩效_机构绩效_中低风险组统计", "机构绩效_机构绩效_中高风险组统计"]
              "统计分析_病案统计" -> ["统计分析_病案统计_DRG病案入组统计"]
              "统计分析_肿瘤统计" -> ["统计分析_肿瘤统计_分化统计", "统计分析_肿瘤统计_发病部分统计", "统计分析_肿瘤统计_肿瘤患者T0期统计", "统计分析_肿瘤统计_肿瘤患者N0期统计"]
              "财务指标_机构收入" -> ["财务指标_机构收入_医疗收入", "财务指标_机构收入_医疗治疗收入", "财务指标_机构收入_管理收入", "财务指标_机构收入_耗材收入", "财务指标_机构收入_西药制品收入", "财务指标_机构收入_中药收入"]
            end
          data = Enum.map(csv, fn x ->
                  tool = Stat.Key.tool(Stat.page_en(x))|>Enum.map(fn x -> x.cn end)
                  case length(tool) do
                    0 -> x <> ".csv"
                    _ -> Enum.map(tool, fn x2 -> x <> "_" <> x2 <> ".csv" end)
                  end
                end)|>List.flatten
          [data, "三级菜单"]
      end
    %{data: data, menu: menu}
  end

end
