defmodule LibraryWeb.RuleController do
  use LibraryWeb, :controller
  plug LibraryWeb.Access
  alias Library.RuleMdc
  alias Library.RuleAdrg
  alias Library.RuleDrg
  alias Library.RuleIcd9
  alias Library.RuleIcd10
  alias Library.LibWt4
  alias Library.Key

  def rule(conn, _params) do
    params = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15}, conn.params)
    {result, page_list, page_num, count, tab_type, type, dissect, list, version, year} = rule(params)
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    json conn, %{result: result, page_list: page_list, page_num: page_num, tab_type: tab_type, type: type, dissect: dissect, list: list, version: version, year: year}
  end

  def rule_file(conn, _params) do
    file =
      ["mdc", "adrg", "drg", "icd9", "icd10", "基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据"]
      |>Enum.map(fn x -> x <> ".csv" end)
    json conn, %{data: file}
  end

  def rule_client(conn, _params) do
    params = Map.merge(%{"page" => "1", "type" => "year", "tab_type" => "mdc", "version" => "BJ", "year" => "", "dissect" => "", "rows" => 15}, conn.params)
    {result, page_list, page_num, count, _, _, _, list, _, _} = rule(params)
    result = result
      |>Enum.map(fn x ->
          Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc])
        end)
      |>Enum.map(fn x ->
          x = if(not is_nil(Map.get(x, :adrg)) and is_list(Map.get(x, :adrg)))do %{x | :adrg => Enum.join(x.adrg,",")} else x end
          x = if(not is_nil(Map.get(x, :codes)))do %{x | :codes => Enum.join(x.codes,",")} else x end
          x
        end)
    result =
      case length(result) do
        0 -> []
        _ ->
          [Map.keys(List.first(result))] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    json conn, %{library: result, list: list, count: count, page_list: page_list, page: page_num}
  end

  defp rule(params) do
    %{"page" => page, "type" => type, "tab_type" => tab_type, "version" => version, "year" => year, "dissect" => dissect, "rows" => rows} = params
    rows = to_string(rows)|>String.to_integer
    tab =
      cond do
        tab_type == "mdc" -> RuleMdc
        tab_type == "adrg" -> RuleAdrg
        tab_type == "drg" -> RuleDrg
        tab_type == "icd10" -> RuleIcd10
        tab_type == "icd9" -> RuleIcd9
        true -> LibWt4
      end
    {result, list, page_list, page_num, count, type} =
      if (tab_type not in ["基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据"]) do
        type = String.to_atom(type)
        #判断值
        query =
          cond do
            year != "" and version != "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year and w.version == ^version)

            year != "" and version == "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year)

            year != "" and version == "" and dissect != "" -> from(w in tab)|>where([w], w.year == ^year and w.dissect == ^dissect)

            year != "" and version != "" and dissect != "" -> from(w in tab)|>where([w], w.year == ^year and w.version == ^version and w.dissect == ^dissect)

            year == "" and version != "" and dissect == "" -> from(w in tab)|>where([w], w.version == ^version)

            year == "" and version != "" and dissect != "" -> from(w in tab)|>where([w], w.version == ^version and w.dissect == ^dissect)

            year == "" and version == "" and dissect != "" -> from(w in tab)|>where([w],  w.dissect == ^dissect)

            # year != "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year)
            # version != "" and dissect == "" -> from(w in tab)|>where([w], w.version == ^version)
            # year != "" and dissect == "" -> from(w in tab)|>where([w], w.year == ^year and w.version == ^version)
            # dissect != "" and year == "" -> from(w in tab)|>where([w], w.dissect == ^dissect)
            # year == "" or dissect == "" -> from(w in tab)
            # dissect != "" and year != ""-> from(w in tab)|>where([w], w.dissect == ^dissect and w.year == ^year)
            true -> from(w in tab)
          end
        IO.inspect query
        query = if(type != "" and tab == LibWt4)do query|>where([w], w.type == ^type) else query end
        query =
          if(type != "" and tab != LibWt4)do
            query_type = to_string(type)
            cond do
              query_type in ["诊断性操作", "治疗性操作", "手术室手术", "中医性操作"] -> query|>where([w], w.property == ^query_type)
              true -> query
            end
          else
            query
          end
        num = select(query, [w], count(w.id))
        count = hd(Repo.all(num, [timeout: 1500000]))
        skip = Library.Page.skip(page, rows)
        query = order_by(query, [w], asc: w.code)
            |>limit([w], ^rows)
            |>offset([w], ^skip)
        result = Repo.all(query)
        #取list
        list =
          cond do
            to_string(type) in ["诊断性操作", "治疗性操作", "手术室手术", "中医性操作"] ->
              i = Repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, :year)))
                |>Enum.reject(fn x -> x == nil end)
              case i do
                [] -> []
                _ -> List.first(i)|>Enum.sort
              end
            true ->
              i = Repo.all(from p in tab, select: fragment("array_agg(distinct ?)", field(p, ^type)))
                |>Enum.reject(fn x -> x == nil end)
              case i do
                [] -> []
                _ -> List.first(i)|>Enum.sort
              end
          end
        {page_num, page_list, count_page} = Library.Page.page_list(page, count, rows)
        {result, list, page_list, page_num, count_page, type}
      else
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
        count = query
          |>select([p], count(p.id))
          |>Repo.all
          |>hd

        skip = Library.Page.skip(page, rows)
        #查询
        result = query
          |>limit([p], ^rows)
          |>offset([w], ^skip)
          |>Repo.all
        {page_num, page_list, count_page} = Library.Page.page_list(page, count, rows)
        list = []
        {result, list, page_list, page_num, count_page, type}
      end

    {result, page_list, page_num, count, tab_type, type, dissect, list, version, year}
  end

  def contrast(conn, %{"table" => table, "id" => id}) do
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
    {result, c} =
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
        {result, c}
      else
        {[], []}
      end
    json conn, %{result: result, table: table, contrast: c}
  end

  def details(conn, %{"code" => code, "table" => table, "version" => version}) do
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
    json conn, %{result: result, result1: List.first(result1), table: table}
  end
# 模糊搜索
  def search(conn, _params) do
    %{"page" => page, "table" => table, "code" => code} = Map.merge(%{"page" => "1", "table" => "", "code" => ""}, conn.params)
    skip = Library.Page.skip(page, 10)
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
    {page_num, page_list, _} = Library.Page.page_list(page, count, 10)
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    json conn, %{"table" => result, "page_num" => page_num, "page_list" => page_list}
  end
end
