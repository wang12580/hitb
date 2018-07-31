defmodule Library.RuleQuery do
  import Ecto.Query
  alias Hitb.Page
  alias Hitb.Time
  alias Hitb.Library.RuleMdc, as: HitbRuleMdc
  alias Hitb.Library.LibraryFile, as: HitbLibraryFile
  alias Hitb.Library.RuleAdrg, as: HitbRuleAdrg
  alias Hitb.Library.RuleDrg, as: HitbRuleDrg
  alias Hitb.Library.RuleIcd9, as: HitbRuleIcd9
  alias Hitb.Library.RuleIcd10, as: HitbRuleIcd10
  alias Hitb.Library.LibWt4, as: HitbLibWt4
  alias Hitb.Library.Cdh, as: HitbRuleCdh
  alias Hitb.Library.RuleSymptom, as: HitbRuleSymptom
  alias Hitb.Edit.MyMould, as: HitbRuleMyMould
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
  alias Hitb.Repo, as: HitbRepo
  alias Block.Repo, as: BlockRepo

  #get_rule(页面,类型,表类型,版本,年份,部位,每页记录数量,服务类型(server祸区块链),排序方式,排序字段,查询类型(查询,下载))
  def get_rule(page, type, tab_type, version, year, dissect, rows, server_type, order_type, order, query_type) do
    repo =
      if(server_type == "server")do
        HitbRepo
      else
        BlockRepo
      end
    #生成查询语句
    [query, list] = query(page, type, tab_type, version, year, dissect, rows, server_type, order_type, order, repo)
    count = select(query, [w], count(w.id))
      |>repo.all([timeout: 1500000])
      |>List.first
    skip = Page.skip(page, rows)
    [page_num, page_list, count_page] = Page.page_list(page, count, rows)
    #判断是否未下载
    result =
      case query_type do
        "download" ->
          query
        _ ->
          my_order(query, order_type, String.to_atom(order))|>limit([w], ^rows)|>offset([w], ^skip)
      end
      |>repo.all
    [result, page_list, page_num, count_page, tab_type, type, dissect, list, version, year]
  end

  def query(page, type, tab_type, version, year, dissect, rows, server_type, order_type, order, repo) do
    tab = tab(server_type, tab_type)
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
        tab_type in ["模板"] ->
          from(p in tab)
        true->
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
    list =
      cond do
        tab_type in ["mdc", "adrg", "drg", "icd9", "icd10"] ->
          %{time: ["全部"] ++ repo.all(from p in tab, distinct: true, select: p.year), version: ["全部"] ++ repo.all(from p in tab, distinct: true, select: p.version), org: ["全部"] ++ repo.all(from p in tab, distinct: true, select: p.org)}
        tab_type in ["中药", "中成药", "西药", "模板"] ->
          %{time: [], org: [], version: []}
        true ->
          %{time: ["全部"] ++ repo.all(from p in tab, distinct: true, select: p.year), org: [], version: []}
      end
    [query, list]
  end

  def table(tab_type, tab) do
    cond do
      tab_type in ["基本信息", "街道乡镇代码", "民族", "区县编码", "手术血型", "出入院编码", "肿瘤编码", "科别代码", "病理诊断编码", "医保诊断依据"]->
        cond do
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
      true-> from(w in tab)
    end
  end

  def tab(server_type, filename) do
    case server_type do
      "server" ->
        case filename do
          "icd9" -> HitbRuleIcd9
          "icd10" -> HitbRuleIcd10
          "mdc" -> HitbRuleMdc
          "adrg" -> HitbRuleAdrg
          "drg" -> HitbRuleDrg
          "cdh" -> HitbRuleCdh
          "中药" -> HitbChineseMedicine
          "中成药" -> HitbChineseMedicinePatent
          "西药" -> HitbWesternMedicine
          _ -> HitbLibWt4
        end
      "block" ->
        case filename do
          "icd9" -> BlockRuleIcd9
          "icd10" -> BlockRuleIcd10
          "mdc" -> BlockRuleMdc
          "adrg" -> BlockRuleAdrg
          "drg" -> BlockRuleDrg
          _ -> BlockLibWt4
        end
    end
  end

  def del_key(result) do
    result
    |>Enum.map(fn x ->
        Map.drop(x, [:__meta__, :__struct__, :inserted_at, :updated_at, :id, :icdc, :icdc_az, :icdcc, :nocc_1, :nocc_a, :nocc_aa, :org, :plat, :mdc, :icd9_a, :icd9_aa, :icd10_a, :icd10_aa, :drgs_1, :icd10_acc, :icd10_b, :icd10_bb, :icd10_bcc, :icd9_acc, :icd9_b, :icd9_bb, :icd9_bcc])
      end)
    |>Enum.map(fn x ->
        x = if(not is_nil(Map.get(x, :adrg)) and is_list(Map.get(x, :adrg)))do %{x | :adrg => Enum.join(x.adrg,"，")} else x end
        if(not is_nil(Map.get(x, :codes)))do %{x | :codes => Enum.join(x.codes,"，")}|>Map.delete(:code) else x|>Map.delete(:codes) end
      end)
  end

  defp my_order(query, order_type, order)do
    case order_type do
      "asc" ->
        order_by(query, [w], asc: field(w, ^order))
      "desc" ->
        order_by(query, [w], desc: field(w, ^order))
      _->
        order_by(query, [w], asc: field(w, ^order))
    end
  end

end
