defmodule Library.RuleService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Repo
  # alias Hitb.Time
  alias Hitb.Library.RuleMdc
  alias Hitb.Library.RuleAdrg
  alias Hitb.Library.RuleDrg
  alias Hitb.Library.RuleIcd9
  alias Hitb.Library.RuleIcd10
  alias Hitb.Library.LibWt4
  alias Hitb.Library.ChineseMedicine
  alias Hitb.Library.ChineseMedicinePatent
  alias Hitb.Library.WesternMedicine
  alias Stat.Key

  def rule(page, type, tab_type, version, year, dissect, rows) do
    [result, page_list, page_num, _count, tab_type, type, dissect, list, version, year] = get_rule(page, type, tab_type, version, year, dissect, rows, "server")
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    %{result: result, page_list: page_list, page_num: page_num, tab_type: tab_type, type: type, dissect: dissect, list: list, version: version, year: year}
  end

  def rule_file(server_type) do
    IO.inspect server_type
    case server_type do
      "block" ->
        [["mdc", Block.Repo.all(from p in Block.Library.RuleMdc, select: count(p.id))],
          ["adrg", Block.Repo.all(from p in Block.Library.RuleAdrg, select: count(p.id))],
          ["drg", Block.Repo.all(from p in Block.Library.RuleDrg, select: count(p.id))],
          ["icd9", Block.Repo.all(from p in Block.Library.RuleIcd9, select: count(p.id))],
          ["icd10", Block.Repo.all(from p in Block.Library.RuleIcd10, select: count(p.id))],
          ["基本信息", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "基本信息", select: count(p.id))],
          ["街道乡镇代码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "街道乡镇代码", select: count(p.id))],
          ["民族", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "民族", select: count(p.id))],
          ["区县编码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "区县编码", select: count(p.id))],
          ["手术血型", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "手术血型", select: count(p.id))],
          ["出入院编码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "出入院编码", select: count(p.id))],
          ["肿瘤编码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "肿瘤编码", select: count(p.id))],
          ["科别代码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "科别代码", select: count(p.id))],
          ["病理诊断编码", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "病理诊断编码", select: count(p.id))],
          ["医保诊断依据", Block.Repo.all(from p in Block.Library.LibWt4, where: p.type == "医保诊断依据", select: count(p.id))],
          ["中药", Block.Repo.all(from p in Block.Library.ChineseMedicine, select: count(p.id))],
          ["中成药", Block.Repo.all(from p in Block.Library.ChineseMedicinePatent, select: count(p.id))]
        ]
        |>Enum.map(fn x ->
            [table, count] = x
            if(List.last(count) == 0)do
              []
            else
              table
            end
          end)
        |>List.flatten
        |>Enum.map(fn x -> x <> ".csv" end)
      _ ->
        ["mdc", "adrg", "drg", "icd9", "icd10", "基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据", "中药", "中成药", "西药"]
        |>Enum.map(fn x -> x <> ".csv" end)
    end
  end

  def rule_client(page, type, tab_type, version, year, dissect, rows, server_type) do
    [result, list, count, page_list, page_num] = clinet(page, type, tab_type, version, year, dissect, rows, server_type)
    result =
      case length(result) do
        0 -> []
        _ ->
          [Map.keys(List.first(result))] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    %{library: result, list: list, count: count, page_list: page_list, page: page_num}
  end

  def clinet(page, type, tab_type, version, year, dissect, rows, server_type) do
    [result, page_list, page_num, count, _, _, _, list, _, _] = get_rule(page, type, tab_type, version, year, dissect, rows, server_type)
    result = result
      |>Enum.map(fn x ->
          Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc])
        end)
      |>Enum.map(fn x ->
          x = if(not is_nil(Map.get(x, :adrg)) and is_list(Map.get(x, :adrg)))do %{x | :adrg => Enum.join(x.adrg,",")} else x end
          x = if(not is_nil(Map.get(x, :codes)))do %{x | :codes => Enum.join(x.codes,",")} else x end
          x
        end)
    [result, list, count, page_list, page_num]
  end

  defp get_rule(page, type, tab_type, version, year, dissect, rows, server_type) do
    rows = to_string(rows)|>String.to_integer
    IO.inspect server_type
    tab =
      cond do
        tab_type == "mdc" and server_type == "server" -> RuleMdc
        tab_type == "mdc" and server_type == "block" -> Block.Library.RuleMdc
        tab_type == "adrg" and server_type == "server"  -> RuleAdrg
        tab_type == "adrg" and server_type == "block" -> Block.Library.RuleAdrg
        tab_type == "drg" and server_type == "server"  -> RuleDrg
        tab_type == "drg" and server_type == "block" -> Block.Library.RuleDrg
        tab_type == "icd10" and server_type == "server"  -> RuleIcd10
        tab_type == "icd10" and server_type == "block" -> Block.Library.RuleIcd10
        tab_type == "icd9" and server_type == "server"  -> RuleIcd9
        tab_type == "icd9" and server_type == "block" -> Block.Library.RuleIcd9
        tab_type == "中药" and server_type == "server"  -> ChineseMedicine
        tab_type == "中药" and server_type == "block" -> Block.Library.ChineseMedicine
        tab_type == "中成药" and server_type == "server"  -> ChineseMedicinePatent
        tab_type == "中成药" and server_type == "block" -> Block.Library.ChineseMedicinePatent
        tab_type == "西药" and server_type == "server"  -> WesternMedicine
        true -> if(server_type == "server")do LibWt4 else Block.Library.LibWt4 end
      end
    IO.inspect tab_type
    [result, list, page_list, page_num, count, type] =
      cond do
        tab_type in ["基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据"]->
          ruleOther(type, tab_type, tab, page, rows, server_type)
        tab_type in ["中药", "中成药"] ->
          ruleChinese(type, tab_type, tab, page, rows, server_type)
        tab_type in ["西药"] ->
          ruleEnglish(type, tab_type, tab, page, rows, server_type)
        true->
          ruleWT4(version, year, dissect, tab, type, page, rows, server_type)
      end
    [result, page_list, page_num, count, tab_type, type, dissect, list, version, year]
  end

  def contrast(table, id) do
    tab =
      cond do
        table == "icd9" -> RuleIcd9
        table == "icd10" -> RuleIcd10
        table == "mdc" -> RuleMdc
        table == "adrg" -> RuleAdrg
        table == "drg" -> RuleDrg
      end
    result = String.split(id, "-")
      |>Enum.map(fn x ->
          x = String.to_integer(x)
          Repo.all(from p in tab, where: p.id == ^x)
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

  def details(code, table, version) do
    tab =
      cond do
        table == "icd9" -> RuleIcd9
        table == "icd10" -> RuleIcd10
        table == "mdc" -> RuleMdc
        table == "adrg" -> RuleAdrg
        table == "drg" -> RuleDrg
      end
    result = Repo.all(from p in tab, where: p.code == ^code)
    result1 = Repo.all(from p in tab, where: p.code == ^code and p.version == ^version)
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
    skip = Hitb.Page.skip(page, 10)
    tab =
      cond do
        table == "icd9" -> RuleIcd9
        table == "icd10" -> RuleIcd10
        table == "mdc" -> RuleMdc
        table == "adrg" -> RuleAdrg
        table == "drg" -> RuleDrg
      end
    code = "%" <> code <> "%"
    result = from(w in tab, where: like(w.code, ^code) or like(w.name, ^code))
      |> limit([w], 10)
      |> offset([w], ^skip)
      |> order_by([w], [asc: w.id])
      |> Repo.all
    query = from w in tab, where: like(w.code, ^code) or like(w.name, ^code), select: count(w.id)
    count = hd(Repo.all(query))
    [page_num, page_list, _] = Hitb.Page.page_list(page, count, 10)
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    %{table: result, page_num: page_num, page_list: page_list}
  end

  defp ruleWT4(version, year, dissect, tab, type, page, rows, server_type) do
    type = String.to_atom(type)
    query =
      cond do
        year != "" and version != "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year and w.version == ^version)

        year != "" and version == "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year)

        year != "" and version == "" and dissect != "" -> from(w in tab)|>where([w], w.year == ^year and w.dissect == ^dissect)

        year != "" and version != "" and dissect != "" -> from(w in tab)|>where([w], w.year == ^year and w.version == ^version and w.dissect == ^dissect)

        year == "" and version != "" and dissect == "" -> from(w in tab)|>where([w], w.version == ^version)

        year == "" and version != "" and dissect != "" -> from(w in tab)|>where([w], w.version == ^version and w.dissect == ^dissect)

        year == "" and version == "" and dissect != "" -> from(w in tab)|>where([w],  w.dissect == ^dissect)
        true -> from(w in tab)
      end
    [lib_wt4, repo] = if(server_type == "server")do [LibWt4, Repo] else [Block.Library.LibWt4, Block.Repo]end
    query = if(type != "" and tab == lib_wt4)do query|>where([w], w.type == ^type) else query end
    query =
      if(type != "" and tab != lib_wt4)do
        query_type = to_string(type)
        cond do
          query_type in ["诊断性操作", "治疗性操作", "手术室手术", "中医性操作"] -> query|>where([w], w.property == ^query_type)
          true -> query
        end
      else
        query
      end
    num = select(query, [w], count(w.id))
    count = hd(repo.all(num, [timeout: 1500000]))
    skip = Hitb.Page.skip(page, rows)
    query = if(rows == 0)do query else order_by(query, [w], asc: w.code)|>limit([w], ^rows)|>offset([w], ^skip) end
    result = repo.all(query)
    list =
      cond do
        to_string(type) in ["诊断性操作", "治疗性操作", "手术室手术", "中医性操作"] ->
          i = repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, :year)))
            |>Enum.reject(fn x -> x == nil end)
          case i do
            [] -> []
            _ -> List.first(i)|>Enum.sort
          end
        true ->
          i = repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, ^type)))
            |>Enum.reject(fn x -> x == nil end)
          case i do
            [] -> []
            _ -> List.first(i)|>Enum.sort
          end
      end
    [page_num, page_list, count_page] = Hitb.Page.page_list(page, count, rows)
    [result, list, page_list, page_num, count_page, type]
  end

  defp ruleOther(type, tab_type, tab, page, rows, server_type) do
    query =
      cond do
        type != "year" and type != "" ->
          from(p in tab)
          |>where([p], p.type == ^type)
        tab_type == "基本信息" ->
          from(p in tab)
          |>where([p], p.type == "行政区划" or p.type == "性别" or p.type == "婚姻状况" or p.type == "职业代码" or p.type == "联系人关系" or p.type == "国籍")
        tab_type == "街道乡镇代码"->
          from(p in tab)
          |>where([p], p.type == "街道乡镇代码")
        tab_type == "民族"->
          from(p in tab)
          |>where([p], p.type == "民族")
        tab_type == "区县编码"->
          from(p in tab)
          |>where([p], p.type == "区县编码")
        tab_type == "手术血型"->
          from(p in tab)
          |>where([p], p.type == "切口愈合" or p.type == "手术级别" or p.type == "麻醉方式" or p.type == "血型" or p.type == "Rh")
        tab_type == "出入院编码"->
          from(p in tab)
          |>where([p], p.type == "离院方式" or p.type == "入院病情" or p.type == "入院途径" or p.type == "住院计划")
        tab_type == "肿瘤编码"->
          from(p in tab)
          |>where([p], p.type == "0～Ⅳ肿瘤分期" or p.type == "TNM肿瘤分期" or p.type == "分化程度编码")
        tab_type == "科别代码"->
          from(p in tab)
          |>where([p], p.type == "科别")
        tab_type == "病理诊断编码"->
          from(p in tab)
          |>where([p], p.type == "病理诊断编码(M码)")
        tab_type == "医保诊断依据"->
          from(p in tab)
          |>where([p], p.type == "最高诊断依据" or p.type == "药物过敏" or p.type == "重症监护室名称指标" or p.type == "医疗付费方式" or p.type == "病案质量")
      end
    #计数
    repo = if(server_type == "server")do Repo else Block.Repo end
    count = query
      |>select([p], count(p.id))
      |>repo.all
      |>hd

    skip = Hitb.Page.skip(page, rows)
    #查询
    query = if(rows == 0)do query else query|>limit([w], ^rows)|>offset([w], ^skip) end
    result = query
      |>repo.all
    [page_num, page_list, count_page] = Hitb.Page.page_list(page, count, rows)
    list = []
    [result, list, page_list, page_num, count_page, type]
  end

  defp ruleChinese(type, tab_type, tab, page, rows, server_type) do
    list =
      cond do
        tab_type == "中成药" ->
          i = Repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, :medicine_type)))
            |>Enum.reject(fn x -> x == nil end)
          case i do
            [] -> []
            _ -> List.first(i)|>Enum.sort
          end
        tab_type == "中药" -> []
      end
    query =
      cond do
        type in ["解表药", "清热解毒药", "泻下药", "消导药", "止咳化痰药", "理气药", "温里药", "祛风湿药?", "固涩药", "利水渗湿药", "开窍药"] ->
          from(p in tab)
          |>where([p], p.type == ^type)
        type in list ->
          from(p in tab)
          |>where([p], p.medicine_type == ^type)
        true ->
          from(p in tab)
      end
    repo = if(server_type == "server")do Repo else Block.Repo end
    count = query
      |>select([p], count(p.id))
      |>repo.all
      |>hd
    # count = Repo.all(from p in tab, select: count(p.id)) |>hd
    skip = Hitb.Page.skip(page, rows)
    query = if(rows == 0)do query else query|>limit([w], ^rows)|>offset([w], ^skip) end
    result = query
      |>repo.all
    [page_num, page_list, count_page] = Hitb.Page.page_list(page, count, rows)
    [result, list, page_list, page_num, count_page, type]
  end
  defp ruleEnglish(type, tab_type, tab, page, rows, server_type) do
    IO.inspect "000000000000000000"
    list =
      cond do
        tab_type == "西药" ->
          i = Repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, :dosage_form)))
            |>Enum.reject(fn x -> x == nil end)
          case i do
            [] -> []
            _ -> List.first(i)|>Enum.sort
          end
      end
    query =
    cond do
      type in list ->
        from(p in tab)
        |>where([p], p.dosage_form == ^type)
      true ->
        from(p in tab)
    end
    repo = if(server_type == "server")do Repo else Block.Repo end
    count = query
      |>select([p], count(p.id))
      |>repo.all
      |>hd
    # count = Repo.all(from p in tab, select: count(p.id)) |>hd
    skip = Hitb.Page.skip(page, rows)
    query = if(rows == 0)do query else query|>limit([w], ^rows)|>offset([w], ^skip) end
    result = query
      |>repo.all
    [page_num, page_list, count_page] = Hitb.Page.page_list(page, count, rows)
    [result, list, page_list, page_num, count_page, type]
  end
end
