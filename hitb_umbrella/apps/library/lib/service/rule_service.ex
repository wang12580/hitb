defmodule Library.RuleService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Page
  alias Hitb.Time
  alias Hitb.Repo, as: HitbRepo
  alias Block.Repo, as: BlockRepo
  alias Hitb.Library.RuleSymptom, as: HitbRuleSymptom
  alias Library.RuleQuery
  alias Hitb.Library.LibraryFile, as: HitbLibraryFile
  alias Library.Key
  alias Block.LibraryService

  def json(page, type, tab_type, version, year, dissect, rows, order_type, order) do
    #取得分析结果
    [result, page_list, page_num, _, tab_type, _type, dissect, list, version, _] = RuleQuery.get_rule(page, type, tab_type, version, year, dissect, rows, "server", "asc", "code", "")
    #去除关键字段
    result = Enum.map(result, fn x -> Map.drop(x, [:__meta__, :__struct__]) end)
    %{result: result, page_list: page_list, page_num: page_num, tab_type: tab_type, type: type, dissect: dissect, list: list, version: version, year: year}
  end

  def rule_file(server_type) do
    case server_type do
      "block" -> LibraryService.get_block_file()
      _ ->
        HitbRepo.all(from p in HitbLibraryFile, select: p.file_name)
        |>Enum.map(fn x -> "#{x}.csv" end)
    end
  end

  def rule_client(page, type, tab_type, version, year, dissect, rows, server_type, order_type, order) do
    [result, page_list, page_num, count, _, _, _, list, _, _] = RuleQuery.get_rule(page, type, tab_type, version, year, dissect, rows, server_type, order_type, Key.en(order), "")
    result = RuleQuery.del_key(result)
    result =
      case length(result) do
        0 -> []
        _ ->
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> Key.cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    file_info = HitbRepo.get_by(HitbLibraryFile, file_name: tab_type)
    result =
      case file_info do
        nil -> []
        _ ->
        [["创建时间:#{Time.stime_ecto(file_info.inserted_at)}", "保存时间:#{Time.stime_ecto(file_info.updated_at)};创建用户:#{file_info.insert_user}", "修改用户:#{file_info.update_user}"] | result]
      end
    %{library: result, list: list, count: count, page_list: page_list, page: page_num, sort_value: order, sort_type: order_type}
  end

  #对比
  def contrast(table, id) do
    tab = RuleQuery.tab("server", table)
    result = String.split(id, "-")
      |>Enum.map(fn x ->
          x = String.to_integer(x)
          HitbRepo.all(from p in tab, where: p.id == ^x)
        end)
      |>List.flatten
    [result, c] =
      if(result != [])do
        a1 = List.first(result)
        a2 = List.last(result)
        a =[:name, :code, :version, :property, :option, :dissect, :cc, :mcc]
        b = Enum.map(a, fn x ->
          val1 = Map.get(a1, x)
          val2 = Map.get(a2, x)
          cond do
            val1 == nil -> nil
            val1 == val2 -> [Key.cnkey(x), "一致"]
            val1 !=val2 -> [Key.cnkey(x), "不一致"]
          end
        end)
        c = Enum.reject(b, fn x -> x == nil end)
        result = Enum.map(result, fn x ->
          Map.drop(x, [:__meta__, :__struct__])
        end)
        [result, c]
      else
        [[], []]
      end
    %{result: result, table: table, contrast: c}
  end

  #维度
  def details(code, table, version) do
    tab = RuleQuery.tab("server", table)
    result = HitbRepo.all(from p in tab, where: p.code == ^code)
    result1 = HitbRepo.all(from p in tab, where: p.code == ^code and p.version == ^version)
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    result1 = Enum.map(result1, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
     %{result: result, result1: List.first(result1), table: table}
  end

  # 模糊搜索
  def search(page, table, code) do
    skip = Page.skip(page, 10)
    tab = RuleQuery.tab("server", table)
    code = "%" <> code <> "%"
    result = from(w in tab, where: like(w.code, ^code) or like(w.name, ^code))
      |> limit([w], 10)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
      |> HitbRepo.all
    query = from w in tab, where: like(w.code, ^code) or like(w.name, ^code), select: count(w.id)
    count = hd(HitbRepo.all(query))
    [page_num, page_list, _count] = Page.page_list(page, count, 10)
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    %{table: result, page_num: page_num, page_list: page_list}
  end

  #下载
  def download(filename) do
    [result, _, _, _, _, _, _, _, _, _] = RuleQuery.get_rule(1, "", filename, "", "", "", 0, "server", "", "", "download")
    result = RuleQuery.del_key(result)
    result =
      case length(result) do
        0 -> []
        _ ->
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> Key.cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    %{result: result}
  end

  #搜索
  def rule_search(filename, value, servertype) do
    tab = RuleQuery.tab(servertype, filename)
    #取得要搜索表的表头
    keys =
      case servertype do
        "server" -> HitbRepo.all(from p in tab, limit: 1)
        "block" -> BlockRepo.all(from p in tab, limit: 1)
      end
      |>RuleQuery.del_key|>List.first|>Map.keys
    query = RuleQuery.table(filename, tab)
    query =
      case tab do
        Hitb.Library.LibWt4 ->
          value = "%#{value}%"
          query
          |>where([p], like(p.code, ^value) or like(p.name, ^value) or like(p.year, ^value))
        _ ->
        Enum.reduce(keys, query, fn x, acc ->
          value = "%#{value}%"
          acc
          |>or_where([p],  like(field(p, ^x), ^value))
        end)
      end
    result =
      case servertype do
        "server" -> HitbRepo.all(query)
        "block" -> BlockRepo.all(query)
      end
    result = RuleQuery.del_key(result)
    result =
      case length(result) do
        0 -> []
        _ ->
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> Key.cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    %{result: result}
  end

  def rule_symptom(symptom, icd9_a, icd10_a, pharmacy) do
    symptoms = HitbRepo.get_by(HitbRuleSymptom, symptom: symptom)
    if symptoms != nil do
      symptoms
      |> HitbRuleSymptom.changeset(%{icd9_a: icd9_a, icd10_a: icd10_a, pharmacy: pharmacy})
      |> HitbRepo.update()
      %{success: true, info: "保存成功"}
    else
      body = %{"symptom" => symptom, "icd9_a" => icd9_a, "icd10_a" => icd10_a, "pharmacy" => pharmacy}
      %HitbRuleSymptom{}
      |> HitbRuleSymptom.changeset(body)
      |> HitbRepo.insert()
      %{success: true, info: "保存成功"}
    end
  end

end
