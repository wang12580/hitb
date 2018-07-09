defmodule Library.RuleService do
  # import Ecto
  import Ecto.Query
  alias Hitb.Page
  alias Hitb.Time
  alias Hitb.Repo, as: HitbRepo
  alias Block.Repo, as: BlockRepo
  # alias Hitb.Time
  alias Hitb.Library.RuleMdc, as: HitbRuleMdc
  alias Hitb.Library.LibraryFile, as: HitbLibraryFile
  alias Hitb.Library.RuleAdrg, as: HitbRuleAdrg
  alias Hitb.Library.RuleDrg, as: HitbRuleDrg
  alias Hitb.Library.RuleIcd9, as: HitbRuleIcd9
  alias Hitb.Library.RuleIcd10, as: HitbRuleIcd10
  alias Hitb.Library.LibWt4, as: HitbLibWt4
  alias Hitb.Library.Cdh, as: HitbRuleCdh
  alias Hitb.Library.ChineseMedicine, as: HitbChineseMedicine
  alias Hitb.Library.ChineseMedicinePatent, as: HitbChineseMedicinePatent
  alias Hitb.Library.WesternMedicine, as: HitbWesternMedicine
  alias Hitb.Library.LibraryFile, as: HitbLibraryFile
  alias Block.Library.RuleMdc, as: BlockRuleMdc
  alias Block.Library.RuleAdrg, as: BlockRuleAdrg
  alias Block.Library.RuleDrg, as: BlockRuleDrg
  alias Block.Library.RuleIcd9, as: BlockRuleIcd9
  alias Block.Library.RuleIcd10, as: BlockRuleIcd10
  alias Block.Library.LibWt4, as: BlockLibWt4
  alias Block.Library.ChineseMedicine, as: BlockChineseMedicine
  alias Block.Library.ChineseMedicinePatent, as: BlockChineseMedicinePatent
  # alias Block.Library.WesternMedicine, as: BlockWesternMedicine

  alias Stat.Key

  def rule(page, type, tab_type, version, year, dissect, rows) do
    [result, page_list, page_num, _count, tab_type, _type, dissect, list, version, _year] = get_rule(page, type, tab_type, version, year, dissect, rows, "server")
    result = Enum.map(result, fn x ->
      Map.drop(x, [:__meta__, :__struct__])
    end)
    %{result: result, page_list: page_list, page_num: page_num, tab_type: tab_type, type: type, dissect: dissect, list: list, version: version, year: year}
  end

  def rule_file(server_type) do
    case server_type do
      "block" ->
        [["mdc", BlockRepo.all(from p in BlockRuleMdc, select: count(p.id))],
          ["adrg", BlockRepo.all(from p in BlockRuleAdrg, select: count(p.id))],
          ["drg", BlockRepo.all(from p in BlockRuleDrg, select: count(p.id))],
          ["icd9", BlockRepo.all(from p in BlockRuleIcd9, select: count(p.id))],
          ["icd10", BlockRepo.all(from p in BlockRuleIcd10, select: count(p.id))],
          ["基本信息", BlockRepo.all(from p in BlockLibWt4, where: p.type == "基本信息", select: count(p.id))],
          ["街道乡镇代码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "街道乡镇代码", select: count(p.id))],
          ["民族", BlockRepo.all(from p in BlockLibWt4, where: p.type == "民族", select: count(p.id))],
          ["区县编码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "区县编码", select: count(p.id))],
          ["手术血型", BlockRepo.all(from p in BlockLibWt4, where: p.type == "手术血型", select: count(p.id))],
          ["出入院编码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "出入院编码", select: count(p.id))],
          ["肿瘤编码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "肿瘤编码", select: count(p.id))],
          ["科别代码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "科别代码", select: count(p.id))],
          ["病理诊断编码", BlockRepo.all(from p in BlockLibWt4, where: p.type == "病理诊断编码", select: count(p.id))],
          ["医保诊断依据", BlockRepo.all(from p in BlockLibWt4, where: p.type == "医保诊断依据", select: count(p.id))],
          ["中药", BlockRepo.all(from p in BlockChineseMedicine, select: count(p.id))],
          ["中成药", BlockRepo.all(from p in BlockChineseMedicinePatent, select: count(p.id))]
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
        HitbRepo.all(from p in HitbLibraryFile, select: p.file_name)
        # ["mdc", "adrg", "drg", "icd9", "icd10", "基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据", "中药", "中成药", "西药"]
        |>Enum.map(fn x -> x <> ".csv" end)
    end
  end

  def rule_client(page, type, tab_type, version, year, dissect, rows, server_type) do
    [result, list, count, page_list, page_num] = clinet(page, type, tab_type, version, year, dissect, rows, server_type)
    result =
      case length(result) do
        0 -> []
        _ ->
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    file_info = HitbRepo.get_by(HitbLibraryFile, file_name: tab_type)
    result =
      case file_info do
        nil -> []
        _ ->
        [["创建时间:#{Time.stime_ecto(file_info.inserted_at)}", "保存时间:#{Time.stime_ecto(file_info.updated_at)};创建用户:#{file_info.insert_user}", "修改用户:#{file_info.update_user}"] | result]
      end
    # IO.inspect result
    %{library: result, list: list, count: count, page_list: page_list, page: page_num}
  end

  def clinet(page, type, tab_type, version, year, dissect, rows, server_type) do
    [result, page_list, page_num, count, _, _, _, list, _, _] = get_rule(page, type, tab_type, version, year, dissect, rows, server_type)
    result = result
      |>Enum.map(fn x ->
          Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc, :icd9_a, :icd9_aa, :icd10_a, :icd10_aa, :drgs_1, :icd10_acc, :icd10_b, :icd10_bb, :icd10_bcc, :icd9_acc, :icd9_b, :icd9_bb, :icd9_bcc])
        end)
      |>Enum.map(fn x ->
          x = if(not is_nil(Map.get(x, :adrg)) and is_list(Map.get(x, :adrg)))do %{x | :adrg => Enum.join(x.adrg,",")} else x end
          x = if(not is_nil(Map.get(x, :codes)))do %{x | :codes => Enum.join(x.codes,",")} else x end
          x
        end)
    [result, list, count, page_list, page_num]
  end

  defp get_rule(page, type, tab_type, version, year, dissect, rows, server_type) do
    rows = if(is_integer(rows))do rows else String.to_integer(rows) end
    repo = if(server_type == "server")do HitbRepo else BlockRepo end
    tab =
      cond do
        tab_type == "mdc" and server_type == "server" -> HitbRuleMdc
        tab_type == "adrg" and server_type == "server"  -> HitbRuleAdrg
        tab_type == "drg" and server_type == "server"  -> HitbRuleDrg
        tab_type == "icd10" and server_type == "server"  -> HitbRuleIcd10
        tab_type == "icd9" and server_type == "server"  -> HitbRuleIcd9
        tab_type == "中药" and server_type == "server"  -> HitbChineseMedicine
        tab_type == "中成药" and server_type == "server"  -> HitbChineseMedicinePatent
        tab_type == "西药" and server_type == "server"  -> HitbWesternMedicine
        tab_type == "mdc" and server_type == "block" -> BlockRuleMdc
        tab_type == "adrg" and server_type == "block" -> BlockRuleAdrg
        tab_type == "drg" and server_type == "block" -> BlockRuleDrg
        tab_type == "icd10" and server_type == "block" -> BlockRuleIcd10
        tab_type == "icd9" and server_type == "block" -> BlockRuleIcd9
        tab_type == "中药" and server_type == "block" -> BlockChineseMedicine
        tab_type == "中成药" and server_type == "block" -> BlockChineseMedicinePatent
        true -> if(server_type == "server")do HitbLibWt4 else BlockLibWt4 end
      end
    query =
      cond do
        tab_type in ["基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据"]->
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
        tab_type in ["中药", "中成药"] ->
          cond do
            type in ["解表药", "清热解毒药", "泻下药", "消导药", "止咳化痰药", "理气药", "温里药", "祛风湿药?", "固涩药", "利水渗湿药", "开窍药"] ->
              from(p in tab)
              |>where([p], p.type == ^type)
            # type in list ->
            #   from(p in tab)
            #   |>where([p], p.medicine_type == ^type)
            true ->
              from(p in tab)
          end
        tab_type in ["西药"] ->
          types = HitbRepo.all(from p in tab, select: fragment("array_agg(distinct ?)", p.dosage_form))|>List.flatten
          cond do
            type in types ->
              from(p in tab)
              |>where([p], p.dosage_form == ^type)
            true ->
              from(p in tab)
          end
        true->
          # query_type = String.to_atom(type)
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
      end
    count = select(query, [w], count(w.id))
      |>repo.all([timeout: 1500000])
      |>List.first
    skip = Page.skip(page, rows)
    query = if(rows == 0)do query else order_by(query, [w], asc: w.inserted_at)|>limit([w], ^rows)|>offset([w], ^skip) end
    result = repo.all(query)
    list =
      case type do
        "time" ->
          repo.all(from p in tab, distinct: true, select: p.year)
        "version" ->
          repo.all(from p in tab, distinct: true, select: p.version)
        "org" ->
          repo.all(from p in tab, distinct: true, select: p.org)
        _ -> []
      end
    [page_num, page_list, _count_page] = Page.page_list(page, count, rows)
    [result, page_list, page_num, count, tab_type, type, dissect, list, version, year]
  end

  def contrast(table, id) do
    tab =
      cond do
        table == "icd9" -> HitbRuleIcd9
        table == "icd10" -> HitbRuleIcd10
        table == "mdc" -> HitbRuleMdc
        table == "adrg" -> HitbRuleAdrg
        table == "drg" -> HitbRuleDrg
      end
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

  def details(code, table, version) do
    tab =
      cond do
        table == "icd9" -> HitbRuleIcd9
        table == "icd10" -> HitbRuleIcd10
        table == "mdc" -> HitbRuleMdc
        table == "adrg" -> HitbRuleAdrg
        table == "drg" -> HitbRuleDrg
      end
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
    tab =
      cond do
        table == "icd9" -> HitbRuleIcd9
        table == "icd10" -> HitbRuleIcd10
        table == "mdc" -> HitbRuleMdc
        table == "adrg" -> HitbRuleAdrg
        table == "drg" -> HitbRuleDrg
      end
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

  def rule_down(filename) do
    tab =
      cond do
        filename == "icd9.csv" -> HitbRuleIcd9
        filename == "icd10.csv" -> HitbRuleIcd10
        filename == "mdc.csv" -> HitbRuleMdc
        filename == "adrg.csv" -> HitbRuleAdrg
        filename == "drg.csv" -> HitbRuleDrg
        filename == "cdh.csv" -> HitbRuleCdh
      end
    result = HitbRepo.all(from p in tab)
    result = result
      |>Enum.map(fn x ->
          Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc, :icd9_a, :icd9_aa, :icd10_a, :icd10_aa, :drgs_1, :icd10_acc, :icd10_b, :icd10_bb, :icd10_bcc, :icd9_acc, :icd9_b, :icd9_bb, :icd9_bcc])
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
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    IO.inspect result
    %{result: result}
  end

  defp cn(key) do
    case to_string(key) do
      "code" -> "编码"
      "name" -> "名称"
      "type" -> "分类"
      "year" -> "年份"
      "version" -> "版本"
      "adrg" -> "ADRG编码"
      "codes" -> "编码"
      "dissect" -> "部位"
      "option" -> "选项"
      "property" -> "属性"
      "cc" -> "CC"
      "mcc" -> "MCC"
      "consumption" -> "用量"
      "effect" -> "功效"
      "indication" -> "适应症"
      "meridian" -> "归经"
      "name_1" -> "别名"
      "need_attention" -> "注意事项"
      "sexual_taste" -> "性味"
      "toxicity" -> "毒性"
      "department_limit" -> "限医疗机构等级"
      "medicine_type" -> "类型"
      "org_limit" -> "医疗"
      "other_limit" -> "其他限制"
      "other_spec" -> "其他规格"
      "user_limit" -> "人员限制"
      "medicine_code" -> "药品编号"
      "dosage_form" -> "剂型"
      "en_name" -> "英文名称"
      "first_level" -> "一级分类"
      "third_level" -> "三级分类"
      "second_level" -> "二级分类"
      "reimbursement_restrictions" -> "报销限制内容"
      "zh_name" -> "中文名称"
      "hash" -> "哈希值"
      "previous_hash" -> "上一条哈希值"
      _ -> to_string(key)
    end
  end
end
