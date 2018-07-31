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
  alias Stat.Key

  def rule_json(page, type, tab_type, version, year, dissect, rows) do
    [result, page_list, page_num, _count, tab_type, _type, dissect, list, version, _year] = RuleQuery.get_rule(page, type, tab_type, version, year, dissect, rows, "server", "asc", "")
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
            [table, count] = x|>List.flatten
            if(count == 0)do
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

  def rule_client(page, type, tab_type, version, year, dissect, rows, server_type, sort_type, sort_value) do
    [result, list, count, page_list, page_num] = clinet(page, type, tab_type, version, year, dissect, rows, server_type, sort_type, en(sort_value))
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
    %{library: result, list: list, count: count, page_list: page_list, page: page_num, sort_type: sort_type, sort_value: sort_value}
  end

  def clinet(page, type, tab_type, version, year, dissect, rows, server_type, sort_type, sort_value) do
    [result, page_list, page_num, count, _, _, _, list, _, _] = RuleQuery.get_rule(page, type, tab_type, version, year, dissect, rows, server_type, sort_type, sort_value)
    result = RuleQuery.results(result)
    [result, list, count, page_list, page_num]
  end

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

  def rule_down(filename) do
    tab = RuleQuery.tab("server", filename)
    query = RuleQuery.table(filename, tab)
    result = HitbRepo.all(query)
    result = RuleQuery.results(result)
    result =
      case length(result) do
        0 -> []
        _ ->
          keys = Map.keys(List.first(result))|>Enum.map(fn x -> cn(x) end)
          [keys] ++ Enum.map(result, fn x -> Map.values(x) end)
      end
    %{result: result}
  end

  def rule_search(filename, value, servertype) do
    tab = RuleQuery.tab(servertype, filename)
    result =
      case servertype do
        "server" -> HitbRepo.all(from p in tab, limit: 1)
        "block" -> BlockRepo.all(from p in tab, limit: 1)
      end
    result = result
      |>Enum.map(fn x ->
          Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc, :icd9_a, :icd9_aa, :icd10_a, :icd10_aa, :drgs_1, :icd10_acc, :icd10_b, :icd10_bb, :icd10_bcc, :icd9_acc, :icd9_b, :icd9_bb, :icd9_bcc])
        end)
      keys = hd(result)|>Map.keys()
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
      result = RuleQuery.results(result)
      result =
        case length(result) do
          0 -> []
          _ ->
            keys = Map.keys(List.first(result))|>Enum.map(fn x -> cn(x) end)
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
     # HitbRepo.get_by(HitbCda, username: username, name: filename)
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

  def en(key) do
    case to_string(key) do
      "编码" -> "code"
      "名称" -> "name"
      "分类" -> "type"
      "年份" -> "year"
      "版本" -> "version"
      "ADRG编码" -> "adrg"
      "部位" -> "dissect"
      "选项" -> "option"
      "属性" -> "property"
      "CC" -> "cc"
      "MCC" -> "mcc"
      "用量" -> "consumption"
      "功效" -> "effect"
      "适应症" -> "indication"
      "归经" -> "meridian"
      "别名" -> "name_1"
      "注意事项" -> "need_attention"
      "性味" -> "sexual_taste"
      "毒性" -> "toxicity"
      "限医疗机构等级" -> "department_limit"
      "类型" -> "medicine_type"
      "医疗" -> "org_limit"
      "其他限制" -> "other_limit"
      "其他规格" -> "other_spec"
      "人员限制" -> "user_limit"
      "药品编号" -> "medicine_code"
      "剂型" -> "dosage_form"
      "英文名称" -> "en_name"
      "一级分类" -> "first_level"
      "三级分类" -> "third_level"
      "二级分类" -> "second_level"
      "报销限制内容" -> "reimbursement_restrictions"
      "中文名称" -> "zh_name"
      "哈希值" -> "hash"
      "上一条哈希值" -> "previous_hash"
      "键" -> "key"
      "值" -> "value"
      _ ->to_string(key)
    end
  end
end
