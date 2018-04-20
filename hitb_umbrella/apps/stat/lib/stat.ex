defmodule Stat do
  @moduledoc """
  Stat keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  #页面中文
  def page_en(page_type) do
    case page_type do
      "机构分析_基础分析" -> "base"
      "机构绩效_机构效率_床位指标" -> "jgjx_cw"
      "机构绩效_机构工作量_医疗检查工作量" -> "jgjx_yljc"
      "机构绩效_机构工作量_医疗治疗工作量" -> "jgjx_ylzl"
      "机构绩效_机构工作量_医技工作量" -> "jgjx_yj"
      "机构绩效_机构工作量_管理工作量" -> "jgjx_gl"
      "机构绩效_机构工作量_护理工作量" -> "jgjx_hl"
      "机构绩效_机构工作量_重症监护室工作量" -> "jgjx_zzjh"
      "机构绩效_机构绩效_低风险组统计" -> "jgjx_dfx"
      "机构绩效_机构绩效_中低风险组统计" -> "jgjx_zdfx"
      "机构绩效_机构绩效_中高风险组统计" -> "jgjx_zgfx"
      "机构绩效_机构绩效_高风险组统计" -> "jgjx_gfx"
      "财务指标_机构收入_医疗收入" -> "cwzb_yl"
      "财务指标_机构收入_医疗治疗收入" -> "cwzb_ylzl"
      "财务指标_机构收入_医技收入" -> "cwzb_yj"
      "财务指标_机构收入_管理收入" -> "cwzb_gl"
      "财务指标_机构收入_耗材收入" -> "cwzb_hc"
      "财务指标_机构收入_西药制品收入" -> "cwzb_xy"
      "财务指标_机构收入_中药收入" -> "cwzb_zy"
      "财务指标_机构收入_护理收入" -> "cwzb_hl"
      "财务指标_医保控费_本市城镇职工基本医疗保险患者支付统计" -> "cwzb_bszg"
      "财务指标_医保控费_外埠城镇职工基本医疗保险患者支付统计" -> "cwzb_wbzg"
      "财务指标_医保控费_本市城镇居民基本医疗保险患者支付统计" -> "cwzb_bsjm"
      "财务指标_医保控费_外埠城镇居民基本医疗保险患者支付统计" -> "cwzb_wbjm"
      "财务指标_医保控费_本市新型农村合作医疗患者支付统计" -> "cwzb_bsnc"
      "财务指标_医保控费_外埠新型农村合作医疗患者支付统计" -> "cwzb_wbnc"
      "财务指标_医保控费_贫困救助患者支付统计" -> "cwzb_pkjz"
      "财务指标_医保控费_商业医疗保险患者支付统计" -> "cwzb_sybx"
      "财务指标_医保控费_全公费患者支付统计" -> "cwzb_gf"
      "财务指标_医保控费_全自费患者支付统计" -> "cwzb_zf"
      "财务指标_医保控费_其他社会保险患者支付统计" -> "cwzb_shbx"
      "财务指标_医保控费_其他患者支付统计" -> "cwzb_qt"
      "医疗质量_重返率_重返情况" -> "ylzl_cfqk"
      "医疗质量_治愈效果_离院情况" -> "ylzl_lyqk"
      "医疗质量_手术质量_手术质量分析" -> "ylzl_sszl"
      "医疗质量_手术质量_负性事件分析" -> "ylzl_fxsj"
      "医疗质量_负性事件_压疮" -> "ylzl_yc"
      "医疗质量_负性事件_护理" -> "ylzl_hl"
      "医疗质量_负性事件_药物" -> "ylzl_yw"
      "医疗质量_负性事件_输血" -> "ylzl_sx"
      "医疗质量_负性事件_感染" -> "ylzl_gr"
      "医疗质量_负性事件_跌倒、坠床" -> "ylzl_dd"
      "统计分析_病案统计_病案质量统计" -> "tjfx_bazl"
      "统计分析_病案统计_病案统计" -> "tjfx_batj"
      "统计分析_病案统计_DRG病案入组统计" -> "tjfx_drg"
      "统计分析_输血统计_Rh阳性全血使用统计" -> "tjfx_rhyang"
      "统计分析_输血统计_Rh阴性全血使用统计" -> "tjfx_rhyin"
      "统计分析_输血统计_血型统计" -> "tjfx_blood"
      "统计分析_输血统计_RH阳性患者统计" -> "tjfx_rhyang2"
      "统计分析_输血统计_RH阴性患者统计" -> "tjfx_rhyin2"
      "统计分析_输血统计_RH不详患者统计" -> "tjfx_nrh"
      "统计分析_输血统计_ 成分血统计" -> "tjfx_cfx"
      "统计分析_输血统计_患者来源统计" -> "tjfx_hzly"
      "统计分析_输血统计_诊断依据统计" -> "tjfx_zdyj"
      "统计分析_肿瘤统计_分化统计" -> "tjfx_fh"
      "统计分析_肿瘤统计_发病部分统计" -> "tjfx_fbbf"
      "统计分析_肿瘤统计_肿瘤患者T0期统计" -> "tjfx_zlt0"
      "统计分析_肿瘤统计_肿瘤患者N0期统计" -> "tjfx_zln0"
      "统计分析_肿瘤统计_肿瘤患者M0期统计" -> "tjfx_zlm0"
      "统计分析_新生儿统计_新生儿出生统计" -> "tjfx_xse"
      "统计分析_新生儿统计_分娩方式统计" -> "tjfx_fmfs"
      "统计分析_新生儿统计_新生儿出生缺陷统计" -> "tjfx_xseqx"
      "统计分析_新生儿统计_出生胎数统计" -> "tjfx_csts"
      "统计分析_手术统计_麻醉统计" -> "tjfx_mz"
      "统计分析_手术统计_甲类切口统计" -> "tjfx_jlqk"
      "统计分析_手术统计_乙类切口统计" -> "tjfx_ylqk"
      "统计分析_手术统计_其他切口统计" -> "tjfx_qtqk"
      "统计分析_手术统计_手术级别统计" -> "tjfx_ssjb"
      _ -> "base"
    end
  end
end
