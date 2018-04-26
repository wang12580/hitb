defmodule StatWeb.ClientController do
  use StatWeb, :controller
  plug StatWeb.Access
  alias Stat.MyRepo

  def stat_create(conn, %{"data" => data, "username" => username}) do
    filename = Hitbserver.Time.sdata_date2() <> "对比分析.csv"
    case Repo.get_by(Stat.ClientStat, filename: filename, username: username) do
      nil ->
        %Stat.ClientStat{}
        |> Stat.ClientStat.changeset(%{data: data, username: username, filename: filename})
        |> Repo.insert
        json conn, %{success: true, filename: filename}
      _ ->
        json conn, %{success: false, filename: filename}
    end
  end

  def stat_client(conn, _params) do
    %{"page" => page, "page_type" => page_type, "type" => type, "tool_type" => tool_type, "org" => org, "time" => time, "drg" => drg, "order" => order, "order_type" => order_type, "username" => username, "rows" => rows} = Map.merge(%{"page" => "1", "type" => "org", "tool_type" => "total", "org" => "", "time" => "", "drg" => "", "order" => "org", "page_type" => "base", "order_type" => "asc", "username" => "", "rows" => 13}, conn.params)
    files = Repo.all(from p in Stat.ClientStat, where: p.username == ^username, select: p.filename)|>List.flatten|>Enum.uniq
    if(page_type <> ".csv" in files)do
      stat = Repo.get_by(Stat.ClientStat, filename: page_type <> ".csv", username: username)
      json conn, %{stat: Poison.decode!(stat.data)}
    else
      page_type = Stat.page_en(page_type)
      rows = to_string(rows)|>String.to_integer
      #获取分析结果
      {stat, list, tool, page_list, _, count, _, _, _} = MyRepo.getstat(username, page, type, tool_type, org, time, drg, order, order_type, page_type, rows, "stat")
      #存储在自定义之前最后一次url
      Hitbserver.ets_insert(:stat_drg, "defined_url_" <> username, {page, type, tool_type, drg, order, order_type, page_type, org})
      stat = Stat.Rand.rand(stat)
      stat = stat|>List.delete_at(0)
      json conn, %{stat: stat, count: count, page: page, tool: tool, list: list, page_list: page_list, page_type: page_type, order: order, order_type: order_type}
    end
  end

  def stat_file(conn, _params) do
    %{"name" => name, "username" => username} = Map.merge(%{"name" => ""}, conn.params)
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
            "保存的对比分析" -> [Repo.all(from p in Stat.ClientStat, where: p.username == ^username, select: p.filename)|>List.flatten|>Enum.uniq, "二级菜单"]
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
                  sql = "select gettool('', '', '', '', '', '" <> Stat.page_en(x) <> "')"
                  tool = Postgrex.query!(Hitbserver.ets_get(:postgresx, :pid), sql, [], [timeout: 15000000]).rows
                    |>List.flatten
                    |>Enum.reject(fn x -> x == "" end)
                  case length(tool) do
                    0 -> x <> ".csv"
                    _ -> Enum.map(tool, fn x2 -> x <> "_" <> x2 <> ".csv" end)
                  end
                end)|>List.flatten
          [data, "三级菜单"]
      end
    json conn, %{data: data, menu: menu}
  end

end
