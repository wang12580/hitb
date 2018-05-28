defmodule Stat.Key do
  alias Hitb.Repo
  alias Hitb.Server.User

  #通用key求得
  def key(username, drg, type, tool_type, page_type) do
    keys = key(username, page_type, tool_type)
    #拼接key
    if(type in ["drg", "adrg", "mdc"] or drg != "")do
      keys = keys -- ["drg2"]
      ["org", "time", "drg2"] ++ (keys -- ["org", "time"])
    else
      ["org", "time"] ++ (keys -- ["org", "time"])
    end
  end

  defp key(username, page_type, tool_type) do
    case page_type do
      "defined" -> #自定义指标
        key = Repo.get_by(User, username: username).key
        if(key)do key else [] end
      "base" -> #机构分析指标
        ["weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"]
      "jgjx_cw" -> #床位指标
        ["sjkfzc_num", "sjzyzc_num", "cyzzyzc_num", "pjkfbc_num", "bczz_num", "bcgzr_num", "cyzpjzy_num", "bcsy_rate", "num_sum"]
      "jgjx_yljc" -> #医疗检查工作量
        ["ylsy_num", "zl_num", "zl_rate", "jc_num", "jc_rate", "js_num", "js_rate", "num_sum"]
      "jgjx_ylzl" -> #医疗治疗工作量
        case tool_type do
          "total" -> ["wlzl_num", "jrzl_num", "tszl_num", "kfzl_num", "zyzl_num", "ybzl_num", "jszl_num", "num_sum"]
          "rate" -> ["wlzl_rate", "jrzl_rate", "tszl_rate", "kfzl_rate", "zyzl_rate", "ybzl_rate", "jszl_rate", "num_sum"]
        end
      "jgjx_yj" -> #医技工作量
        case tool_type do
          "total" -> ["yjsy_num", "hsjc_num", "hszl_num", "cszl_num", "fszl_num", "hy_num", "bl_num", "num_sum"]
          "rate" -> ["yjsy_rate", "hsjc_rate", "hszl_rate", "cszl_rate", "fszl_rate", "hy_rate", "bl_rate", "num_sum"]
        end
      "jgjx_zzjh" -> #重症监护室工作量
        case tool_type do
          "total" -> ["ccu_num", "ricu_num", "sicu_num", "nicu_num", "picu_num", "other_num", "num_sum"]
          "rate" -> ["ccu_rate", "ricu_rate", "sicu_rate", "nicu_rate", "picu_rate", "other_rate", "num_sum"]
        end
      "jgjx_dfx" -> #低风险组统计
        ["dfx_age", "ysj_num", "wsj_num", "dfx_num", "dfxsw_num", "dfxsw_rate", "num_sum"]
      "jgjx_zdfx" -> #中低风险组统计
        ["zdfx_age", "zdysj_num", "zdwsj_num", "zdfx_num", "zdfxsw_num", "zdfxsw_rate", "num_sum"]
      "jgjx_zgfx" -> #中高风险组统计
        ["zgfx_age", "zgysj_num", "zgwsj_num", "zgfx_num", "zgfxsw_num", "zgfxsw_rate", "num_sum"]
      "jgjx_gfx" -> #高风险组统计
        ["gfx_age", "gysj_num", "gwsj_num", "gfx_num", "gfxsw_num", "gfxsw_rate", "num_sum"]
      "cwzb_yl" -> #医疗收入
        case tool_type do
          "total" -> ["yl_expense", "zl_expense", "ybjc_expense", "js_expense", "mz_expense", "ss_expense", "num_sum"]
          "avg" -> ["avg_yl", "avg_zl", "avg_ybjc", "avg_js", "avg_mz", "avg_ss", "num_sum"]
          "rate" -> ["yl_rate", "zlf_rate", "ybjcf_rate", "jsf_rate", "mzf_rate", "ssf_rate", "num_sum"]
        end
      "cwzb_ylzl" -> #医疗治疗收入
        case tool_type do
          "total" -> ["jrzl_expense", "tszl_expense", "kfzl_expense", "zyzl_expense", "ybzl_expense", "jszl_expense", "wlzl_expense", "num_sum"]
          "avg" -> ["avg_jrzl", "avg_tszl", "avg_kfzl", "avg_zyzl", "avg_ybzl", "avg_jszl", "avg_wlzl", "num_sum"]
          "rate" -> ["jrzlf_rate", "tszlf_rate", "kfzlf_rate", "zyzlf_rate", "ybzlf_rate", "jszlf_rate", "wlzlf_rate", "num_sum"]
        end
      "cwzb_yj" -> #医技收入
        case tool_type do
          "total" -> ["hsjc_expense", "hszl_expense", "cs_expense", "fs_expense", "hy_expense", "bl_expense", "num_sum"]
          "avg" -> ["avg_hsjc", "avg_hszl", "avg_cs", "avg_fs", "avg_hy", "avg_bl", "num_sum"]
          "rate" -> ["hsjc_rate", "hszl_rate", "csf_rate", "fsf_rate", "hyf_rate", "blf_rate", "num_sum"]
        end
      "cwzb_zy" -> #中药收入
        ["zc_expense", "zcy_expense", "avg_zc", "avg_zcy", "zc_rate", "zcy_rate", "num_sum"]
      "cwzb_hl" -> #护理收入
        ["hlze_num", "hlzl_num", "hlf_num", "hlzl_avg", "hlf_avg", "hlze_rate", "hlzl_rate", "hlf_rate", "num_sum"]
      "cwzb_hc" -> #耗材收入
        case tool_type do
          "total" -> ["ypzef", "zlyc_expense", "jryc_expense", "ssyc_expense", "jcyc_expense", "hc_expense", "num_sum"]
          "avg" -> ["avg_yp", "avg_zlyc", "avg_jryc", "avg_ssyc", "avg_jcyc", "avg_hc", "num_sum"]
          "rate" -> ["yp_rate", "zlyc_rate", "jryc_rate", "ssyc_rate", "jcyc_rate", "hc_rate", "num_sum"]
        end
      "cwzb_xy" -> #西药制品费用
        case tool_type do
          "total" -> ["sx_expense", "xy_expense", "kjy_expense", "bdb_expense", "qdb_expense", "nxyz_expense", "xbyz_expense", "num_sum"]
          "avg" -> ["avg_sxf", "avg_xyf", "avg_kjy", "avg_bdb", "avg_qdb", "avg_nxyz", "avg_xbyz", "num_sum"]
          "rate" -> ["sxf_rate", "xyf_rate", "kjy_rate", "bdb_rate", "qdb_rate", "nxyz_rate", "xbyz_rate", "num_sum"]
        end
      "cwzb_gl" -> #管理收入
        case tool_type do
          "total" -> ["glze_expense", "jhfz_expense", "cw_expense", "gh_expense", "sy_expense", "other_expense", "num_sum"]
          "avg" -> ["avg_glze", "avg_jhfz", "avg_cw", "avg_gh", "avg_sy", "avg_other", "num_sum"]
          "rate" -> ["glze_rate", "jhfzf_rate", "cwf_rate", "ghf_rate", "syf_rate", "otherf_rate", "num_sum"]
        end
      "cwzb_bszg" -> #本市城镇职工基本医疗保险患者支付统计
        case tool_type do
          "total" -> ["bszg_num", "bszgzf_num", "bszgyl_num", "bszgyj_num", "bszgypj_num", "bszghl_num", "bszggl_num", "num_sum"]
          "avg" -> ["bszg_avg", "bszgzf_avg", "bszgyl_avg", "bszgyj_avg", "bszgypj_avg", "bszghl_avg", "bszggl_avg", "num_sum"]
          "rate" -> ["bszg_rate", "bszgzf_rate", "bszgyl_rate", "bszgyj_rate", "bszgypj_rate", "bszghl_rate", "bszggl_rate", "num_sum"]
        end
      "cwzb_wbzg" -> #外埠城镇职工基本医疗保险患者支付统计
        case tool_type do
          "total" -> ["wbzg_num", "wbzgzf_num", "wbzgyl_num", "wbzgyj_num", "wbzgypj_num", "wbzghl_num", "wbzggl_num", "num_sum"]
          "avg" -> ["wbzg_avg", "wbzgzf_avg", "wbzgyl_avg", "wbzgyj_avg", "wbzgypj_avg", "wbzghl_avg", "wbzggl_avg", "num_sum"]
          "rate" -> ["wbzg_rate", "wbzgzf_rate", "wbzgyl_rate", "wbzgyj_rate", "wbzgypj_rate", "wbzghl_rate", "wbzggl_rate", "num_sum"]
        end
      "cwzb_bsjm" -> #本市城镇居民基本医疗保险患者支付统计
        case tool_type do
          "total" -> ["bsjm_num", "bsjmzf_num", "bsjmyl_num", "bsjmyj_num", "bsjmypj_num", "bsjmhl_num", "bsjmgl_num", "num_sum"]
          "avg" -> ["bsjm_avg", "bsjmzf_avg", "bsjmyl_avg", "bsjmyj_avg", "bsjmypj_avg", "bsjmhl_avg", "bsjmgl_avg", "num_sum"]
          "rate" -> ["bsjm_rate", "bsjmzf_rate", "bsjmyl_rate", "bsjmyj_rate", "bsjmypj_rate", "bsjmhl_rate", "bsjmgl_rate", "num_sum"]
        end
      "cwzb_wbjm" -> #外埠城镇居民基本医疗保险患者支付统计
        case tool_type do
          "total" -> ["wbjm_num", "wbjmzf_num", "wbjmyl_num", "wbjmyj_num", "wbjmypj_num", "wbjmhl_num", "wbjmgl_num", "num_sum"]
          "avg" -> ["wbjm_avg", "wbjmzf_avg", "wbjmyl_avg", "wbjmyj_avg", "wbjmypj_avg", "wbjmhl_avg", "wbjmgl_avg", "num_sum"]
          "rate" -> ["wbjm_rate", "wbjmzf_rate", "wbjmyl_rate", "wbjmyj_rate", "wbjmypj_rate", "wbjmhl_rate", "wbjmgl_rate", "num_sum"]
        end
      "cwzb_bsnc" -> #本市新型农村合作医疗患者支付统计
        case tool_type do
          "total" -> ["bsxnh_num", "bsxnhzf_num", "bsxnhyl_num", "bsxnhyj_num", "bsxnhypj_num", "bsxnhhl_num", "bsxnhgl_num", "num_sum"]
          "avg" -> ["bsxnh_avg", "bsxnhzf_avg", "bsxnhyl_avg", "bsxnhyj_avg", "bsxnhypj_avg", "bsxnhhl_avg", "bsxnhgl_avg", "num_sum"]
          "rate" -> ["bsxnh_rate", "bsxnhzf_rate", "bsxnhyl_rate", "bsxnhyj_rate", "bsxnhypj_rate", "bsxnhhl_rate", "bsxnhgl_rate", "num_sum"]
        end
      "cwzb_wbnc" -> #外埠新型农村合作医疗患者支付统计
        case tool_type do
          "total" -> ["wbxnh_num", "wbxnhzf_num", "wbxnhyl_num", "wbxnhyj_num", "wbxnhypj_num", "wbxnhhl_num", "wbxnhgl_num", "num_sum"]
          "avg" -> ["wbxnh_avg", "wbxnhzf_avg", "wbxnhyl_avg", "wbxnhyj_avg", "wbxnhypj_avg", "wbxnhhl_avg", "wbxnhgl_avg", "num_sum"]
          "rate" -> ["wbxnh_rate", "wbxnhzf_rate", "wbxnhyl_rate", "wbxnhyj_rate", "wbxnhypj_rate", "wbxnhhl_rate", "wbxnhgl_rate", "num_sum"]
        end
      "cwzb_pkjz" -> #贫困救助患者支付统计
        case tool_type do
          "total" -> ["pkjz_num", "pkjzzf_num", "pkjzyl_num", "pkjzyj_num", "pkjzypj_num", "pkjzhl_num", "pkjzgl_num", "num_sum"]
          "avg" -> ["pkjz_avg", "pkjzzf_avg", "pkjzyl_avg", "pkjzyj_avg", "pkjzypj_avg", "pkjzhl_avg", "pkjzgl_avg", "num_sum"]
          "rate" -> ["pkjz_rate", "pkjzzf_rate", "pkjzyl_rate", "pkjzyj_rate", "pkjzypj_rate", "pkjzhl_rate", "pkjzgl_rate", "num_sum"]
        end
      "cwzb_sybx" -> #商业医疗保险患者支付统计
        case tool_type do
          "total" -> ["sybx_num", "sybxzf_num", "sybxyl_num", "sybxyj_num", "sybxypj_num", "sybxhl_num", "sybxgl_num", "num_sum"]
          "avg" -> ["sybx_avg", "sybxzf_avg", "sybxyl_avg", "sybxyj_avg", "sybxypj_avg", "sybxhl_avg", "sybxgl_avg", "num_sum"]
          "rate" -> ["sybx_rate", "sybxzf_rate", "sybxyl_rate", "sybxyj_rate", "sybxypj_rate", "sybxhl_rate", "sybxgl_rate", "num_sum"]
        end
      "cwzb_gf" -> #全公费患者支付统计
        case tool_type do
          "total" -> ["qgf_num", "qgfzf_num", "qgfyl_num", "qgfyj_num", "qgfypj_num", "qgfhl_num", "qgfgl_num", "num_sum"]
          "avg" -> ["qgf_avg", "qgfzf_avg", "qgfyl_avg", "qgfyj_avg", "qgfypj_avg", "qgfhl_avg", "qgfgl_avg", "num_sum"]
          "rate" -> ["qgf_rate", "qgfzf_rate", "qgfyl_rate", "qgfyj_rate", "qgfypj_rate", "qgfhl_rate", "qgfgl_rate", "num_sum"]
        end
      "cwzb_zf" -> #全自费患者支付统计
        case tool_type do
          "total" -> ["qzf_num", "qzfyl_num", "qzfyj_num", "qzfypj_num", "qzfhl_num", "qzfgl_num", "num_sum"]
          "avg" -> ["qzf_avg", "qzfyl_avg", "qzfyj_avg", "qzfypj_avg", "qzfhl_avg", "qzfgl_avg", "num_sum"]
          "rate" -> ["qzf_rate", "qzfyl_rate", "qzfyj_rate", "qzfypj_rate", "qzfhl_rate", "qzfgl_rate", "num_sum"]
        end
      "cwzb_shbx" -> #其他社会保险患者支付统计
        case tool_type do
          "total" -> ["qtbx_num", "qtbxzf_num", "qtbxyl_num", "qtbxyj_num", "qtbxypj_num", "qtbxhl_num", "qtbxgl_num", "num_sum"]
          "avg" -> ["qtbx_avg", "qtbxzf_avg", "qtbxyl_avg", "qtbxyj_avg", "qtbxypj_avg", "qtbxhl_avg", "qtbxgl_avg", "num_sum"]
          "rate" -> ["qtbx_rate", "qtbxzf_rate", "qtbxyl_rate", "qtbxyj_rate", "qtbxypj_rate", "qtbxhl_rate", "qtbxgl_rate", "num_sum"]
        end
      "cwzb_qt" -> #其他患者支付统计
        case tool_type do
          "total" -> ["qthz_num", "qthzzf_num", "qthzyl_num", "qthzyj_num", "qthzypj_num", "qthzhl_num", "qthzgl_num", "num_sum"]
          "avg" -> ["qthz_avg", "qthzzf_avg", "qthzyl_avg", "qthzyj_avg", "qthzypj_avg", "qthzhl_avg", "qthzgl_avg", "num_sum"]
          "rate" -> ["qthz_rate", "qthzzf_rate", "qthzyl_rate", "qthzyj_rate", "qthzypj_rate", "qthzhl_rate", "qthzgl_rate", "num_sum"]
        end
      "ylzl_cfqk" -> #医疗质量-重返率-重返情况
        ["is_inhosp31", "inhosp_rate", "num_num1", "num_rate1", "num_num2", "num_rate2", "num_num3", "num_rate3", "num_sum"]
      "ylzl_lyqk" -> #医疗质量-治愈效果-离院情况
        ["yzly_num" , "yzly_rate", "yzzy_num", "yzzy_rate", "yzzsq_num", "yzzsq_rate", "fyzly_num", "fyzly_rate", "num_sum"]
      "zdfhl" -> #诊断符合率
        ["rycyfh_num", "rycyfh_rate", "zdblfh_num", "zdblfh_rate", "ryssfh_num", "ryssfh_rate", "num_sum"]
      "ylzl_sszl" -> #医疗质量-手术质量-手术质量分析
        ["sqday_num", "shday_num", "fjh_num", "fjh_rate", "zdss_num", "sw_num", "sw_rate", "num_sum"]
      "ylzl_fxsj" -> #医疗质量-手术质量-负性事件分析
        ["qklk_num", "qklk_rate", "qkgr_num", "qkgr_rate", "shgr_num", "shgr_rate", "shbf_num", "shbf_rate", "num_sum"]
      "ylzl_szfxsj" -> #术中负性事件
        case tool_type do
          "total" -> ["ssywss_num", "ssywqg_num", "ssywzc_num", "ssywck_num", "ssywcx_num", "ssylyw_num", "sswjsb_num", "ssczbd_num", "num_sum"]
          "rate" -> ["ssywss_rate", "ssywqg_rate", "ssywzc_rate", "ssywck_rate", "ssywcx_rate", "ssylyw_rate", "sswjsb_rate", "ssczbd_rate", "num_sum"]
        end
      "ylzl_yw" -> #医疗质量-负性事件-药物
        ["num_num", "ywfxsj_num", "ywfxsj_rate", "ywgl_num", "ywgl_rate", "ywgc_num", "ywgc_rate", "num_sum"]
      # "ylzl_dd" -> #医疗质量-负性事件-跌倒、坠床
      #   ["num_num", "ywdd_num", "ycdd_rate", "zc_num", "zc_rate"]
      "ylzl_dd" -> #医疗质量--负性事件-治疗
        case tool_type do
          "total" -> ["zlywzl_num", "zlywqg_num", "zlywzc_num", "zlywck_num", "zlywcx_num", "zlylyw_num", "zlwjsb_num", "zlczbd_num", "num_sum"]
          "rate" -> ["zlywzl_rate", "zlywqg_rate", "zlywzc_rate", "zlywck_rate", "zlywcx_rate", "zlylyw_rate", "zlwjsb_rate", "zlczbd_rate", "num_sum"]
          "" -> ["zlywzl_num", "zlywqg_num", "zlywzc_num", "zlywck_num", "zlywcx_num", "zlylyw_num", "zlwjsb_num", "zlczbd_num", "num_sum"]
        end
      "ylzl_yc" -> #医疗质量-负性事件-压疮
        case tool_type do
          "total" -> ["num_num", "ychz_num", "odyc_num", "wdyc_num", "tdyc_num", "fdyc_num", "num_sum"]
          "rate" -> ["ychz_rate", "odyc_rate", "wdyc_rate", "tdyc_rate", "fdyc_rate", "num_sum"]
        end
      "ylzl_hl" -> #医疗质量-负性事件-护理
        case tool_type do
          "total" -> ["num_num", "hlfxsj_num", "syyw_num", "syyl_num", "syyf_num", "syry_num", "sywr_num", "sygl_num", "num_sum"]
          "rate" -> ["hlfxsj_rate", "syyw_rate", "syyl_rate", "syyf_rate", "syry_rate", "sywr_rate", "sygl_rate", "num_sum"]
        end
      "ylzl_sx" -> #医疗质量-负性事件-输血
        case tool_type do
          "total" -> ["num_num", "sxfxsj_num", "sxyw_num", "sxyl_num", "sxyf_num", "sxwr_num", "sxgl_num", "num_sum"]
          "rate" -> ["sxfxsj_rate", "sxyw_rate", "sxyl_rate", "sxyf_rate", "sxwr_rate", "sxgl_rate", "num_sum"]
        end
      "ylzl_gr" -> #医疗质量-负性事件-感染
        case tool_type do
          "total" -> ["szh_num", "czh_num", "ssh_num", "stx_num", "rgjt_num", "ylqj_num", "num_sum"]
          "rate" -> ["szh_rate", "czh_rate", "ssh_rate", "stx_rate", "rgjt_rate", "ylqj_rate", "num_sum"]
        end
      "tjfx_bazl" -> #统计分析-病案统计-病案质量统计
        ["bazlj_num", "bazlj_rate", "bazly_num", "bazly_rate", "bazlb_num", "bazlb_rate", "num_sum"]
      "tjfx_batj" -> #统计分析-病案统计-病案统计
        case tool_type do
          "total" -> ["num_num", "ssls_num", "mzzy_num", "jzzy_num", "ybzf_num", "xnh_num", "qzfbl_num", "qgfbl_num", "num_sum"]
          "rate" -> ["ssls_rate", "mzzy_rate", "jzzy_rate", "ybzf_rate", "xnh_rate", "qzfbl_rate", "qgfbl_rate", "num_sum"]
        end
      "tjfx_drg" -> #统计分析-病案统计-DRG病案入组统计
        ["hos_num", "pc_num", "wrmdc_num", "wrz_num", "qy_num", "drg_rate", "num_num", "num_sum"]
      "tjfx_blood" -> #统计分析-输血统计-血型统计
        case tool_type do
          "total" -> ["blood_num", "ablood_num", "bblood_num", "abblood_num", "oblood_num", "wcblood_num", "num_sum"]
          "rate" -> ["blood_rate", "ablood_rate", "bblood_rate", "abblood_rate", "oblood_rate", "wcblood_rate", "num_sum"]
        end
      "tjfx_rhyang2" -> #统计分析-输血统计-RH阳性患者统计
        ["rhyxa_num", "rhyxa_rate", "rhyxb_num", "rhyxb_rate", "rhyxo_num", "rhyxo_rate", "rhyxab_num", "rhyxab_rate", "num_sum"]
      "tjfx_rhyin2" -> #统计分析-输血统计-RH阴性患者统计
        ["rhya_num", "rhya_rate", "rhyb_num", "rhyb_rate", "rhyo_num", "rhyo_rate", "rhyab_num", "rhyab_rate", "num_sum"]
      "tjfx_nrh" ->  #统计分析-输血统计-RH不详患者统计
        ["rhbxa_num", "rhbxa_rate", "rhbxb_num", "rhbxb_rate", "rhbxo_num", "rhbxo_rate", "rhbxab_num", "rhbxab_rate", "num_sum"]
      "tjfx_rhyang" -> #统计分析-输血统计-Rh阳性全血使用统计
        ["rhyxa_cc", "rhyxb_cc", "rhyxab_cc", "rhyxo_cc", "rhyxacc_rate", "rhyxbcc_rate", "rhyxabcc_rate", "rhyx0cc_rate", "num_sum"]
      "tjfx_rhyin" -> #统计分析-输血统计-Rh阴性全血使用统计
        ["rhyacc_rate", "rhybcc_rate", "rhyabcc_rate", "rhy0cc_rate", "rhya_cc", "rhyb_cc", "rhyab_cc", "rhyo_cc", "num_sum"]
      "tjfx_cfx" -> #统计分析-输血统计- 成分血统计
        case tool_type do
          "total" -> ["num_num", "cfx_num", "hxb_num", "xsb_num", "xj_num", "qx_num", "qtx_num", "num_sum"]
          "avg" -> ["num_num", "cfx_avg", "hxb_avg", "xsb_avg", "xj_avg", "qx_avg", "qtx_avg", "num_sum"]
          "rate" -> ["sum_rate", "cfx_rate", "hxb_rate", "xsb_rate", "xj_rate", "qx_rate", "qtx_rate", "num_sum"]
        end
      "tjfx_hzly" -> #肿瘤患者来源统计
        ["man_num", "man_rate", "woman_num", "woman_rate", "bd_num", "bd_rate", "wd_num", "wd_rate", "num_sum"]
      "tjfx_zdyj" -> #诊断依据统计
        case tool_type do
          "total" -> ["lczg_num", "xxct_num", "sszd_num", "shmy_num", "xbx_num", "bljf_num", "blyf_num", "sjybl_num", "zgzdyj_num", "num_sum"]
          "rate" -> ["lczg_rate", "xxct_rate", "sszd_rate", "shmy_rate", "xbx_rate", "bljf_rate", "blyf_rate", "sjybl_rate", "zgzdyj_rate", "num_sum"]
        end
      "tjfx_fbbf" -> #统计分析-肿瘤统计-发病部分统计
        case tool_type do
          "total" -> ["xhxt_num", "sjxt_num", "hxxt_num", "xyxh_num", "ydxt_num", "nfm_num", "mnxt_num", "szxt_num", "num_sum"]
          "rate" -> ["xhxt_rate", "sjxt_rate", "hxxt_rate", "xyxh_rate", "ydxt_rate", "nfm_rate", "mnxt_rate", "szxt_rate", "num_sum"]
        end
      "tjfx_fh" -> #统计分析-肿瘤统计-分化统计
        case tool_type do
          "total" -> ["zlfq_num", "gfh_num", "zfh_num", "dfh_num", "wfh_num", "wqd_num", "num_sum"]
          "rate" -> ["zlfq_rate", "gfh_rate", "zfh_rate", "dfh_rate", "wfh_rate", "wqd_rate", "num_sum"]
        end
      "tjfx_tbxb" -> #统计分析-肿瘤统计-T、B细胞统计
        ["txb_num", "txb_rate", "bxb_num", "bxb_rate", "ftfbxb_num", "ftfbxb_rate", "nk_num", "nk_rate", "num_sum"]
      "tjfx_zlt0" -> #统计分析-肿瘤统计-肿瘤患者T0期统计
        case tool_type do
          "total" -> ["tl_num", "to_num", "tw_num", "tt_num", "tf_num", "wfpgyf_num", "num_sum"]
          "rate" -> ["tl_rate", "to_rate", "tw_rate", "tt_rate", "tf_rate", "wfpgyf_rate", "num_sum"]
        end
      "tjfx_zln0" -> #统计分析-肿瘤统计-肿瘤患者N0期统计
        case tool_type do
          "total" -> ["nl_num", "no_num", "nw_num", "nt_num", "nf_num", "wfpglb_num", "num_sum"]
          "rate" -> ["nl_rate", "no_rate", "nw_rate", "nt_rate", "nf_rate", "wfpglb_rate", "num_sum"]
        end
      "tjfx_zlm0" -> #统计分析-肿瘤统计-肿瘤患者M0期统计
        ["ml_num", "ml_rate", "mo_num", "mo_rate", "wfpgyc_num", "wfpgyc_rate", "num_sum"]
      "tjfx_jlqk" -> #统计分析-手术统计-甲类切口统计
        ["yjqk_num", "yjqk_rate", "ejqk_num", "ejqk_rate", "sjqk_num", "sjqk_rate", "num_sum"]
      "tjfx_ylqk" -> #统计分析-手术统计-乙类切口统计
        ["yjyqk_num", "yjyqk_rate", "ejyqk_num", "ejyqk_rate", "sjyqk_num", "sjyqk_rate", "num_sum"]
      "tjfx_blqk" -> #丙类切口统计
        ["yjbqk_num", "yjbqk_rate", "ejbqk_num", "ejbqk_rate", "sjbqk_num", "sjbqk_rate", "num_sum"]
      "tjfx_qtqk" -> #统计分析-手术统计-其他切口统计
        ["yss_num", "yss_rate", "yjqtqk_num", "yjqtqk_rate", "ejqtqk_num", "ejqtqk_rate", "sjqtqk_num", "sjqtqk_rate", "num_sum"]
      "tjfx_ssjb" -> #统计分析-手术统计-手术级别统计
        ["ojss_num", "ojss_rate", "wjss_num", "wjss_rate", "tjss_num", "tjss_rate", "fjss_num", "fjss_rate", "num_sum"]
      "tjfx_mz" -> #统计分析-手术统计-麻醉统计
        case tool_type do
          "total" -> ["mz_num", "wmz_num", "qsmz_num", "xrmz_num", "jmmz_num", "jcmz_num", "qymz_num", "zgnmz_num", "num_sum"]
          "rate" -> ["mz_rate", "wmz_rate", "qsmz_rate", "xrmz_rate", "jmmz_rate", "jcmz_rate", "qymz_rate", "zgnmz_rate", "num_sum"]
        end
      "tjfx_fhmz" -> #复合麻醉患者统计
        case tool_type do
          "total" -> ["ymwfh_num", "fhmz_num", "btywfh_num", "btfffh_num", "tsfffh_num", "jxfh_num", "qtmz_num", "num_sum"]
          "rate" -> ["ymwfh_rate", "fhmz_rate", "btywfh_rate", "btfffh_rate", "tsfffh_rate", "jxfh_rate", "qtmz_rate", "num_sum"]
        end
      "tjfx_qtzz" -> #其他阻滞麻醉统计
        ["zwmx_num", "zwmx_rate", "ymw_num", "ymw_rate", "jc_num", "jc_rate", "sj_num", "sj_rate", "num_sum"]
      "tjfx_sjmz" -> #神经阻滞麻醉统计
        case tool_type do
          "total" -> ["bc_num", "yz_num", "qg_num", "zp_num", "per_num", "jg_num", "xy_num", "n_num", "num_sum"]
          "rate" -> ["bc_rate", "yz_rate", "qg_rate", "zp_rate", "per_rate", "jg_rate", "xy_rate", "n_rate", "num_sum"]
        end
      "tjfx_xse" -> #统计分析-新生儿统计-新生儿出生统计
        ["baby_num", "baby_rate", "boy_num", "boy_rate", "girl_num", "girl_rate", "def_num", "def_rate", "num_sum"]
      "tjfx_fmfs" -> #统计分析-新生儿统计-分娩方式统计
        ["ck_num", "ck_rate", "pgc_num", "pgc_rate", "sc_num", "sc_rate", "num_sum"]
      "tjfx_csts" -> #统计分析-新生儿统计-出生胎数统计
        ["dt_num", "dt_rate", "sbt_num", "sbt_rate", "dbt_num", "dbt_rate", "st_num", "st_rate", "num_sum"]
      "tjfx_xseqx" -> #统计分析-新生儿统计-新生儿出生缺陷统计
        case tool_type do
          "total" -> ["xhqx_num", "sjqx_num", "hxqx_num", "xyqx_num", "ydqx_num", "nfmqx_num", "mnqx_num", "szqx_num", "num_sum"]
          "rate" -> ["xhqx_rate", "sjqx_rate", "hxqx_rate", "xyqx_rate", "ydqx_rate", "nfmqx_rate", "mnqx_rate", "szqx_rate", "num_sum"]
        end
    end
  end

  #页面所包含工具
  def tool(page_type) do
    cond do
      page_type in ["base", "jgjx_cw", "jgjx_yljc", "jgjx_gl", "jgjx_hl", "jgjx_dfx", "jgjx_zdfx", "jgjx_zgfx", "jgjx_gfx", "yjgzlzb", "cwzb_zy", "cwzb_hl", "cwzb_pk", "ylzl_cfqk", "ylzl_lyqk", "ylzl_sszl", "ylzl_fxsj", "ylzl_yw", "ylzl_dd", "tjfx_bazl", "tjfx_drg", "tjfx_rhyang", "tjfx_rhyin", "tjfx_rhyang2", "tjfx_rhyin2", "tjfx_nrh",  "tjfx_hzly", "tjfx_zlm0", "tjfx_xse", "tjfx_fmfs", "tjfx_csts", "tjfx_jlqk", "tjfx_ylqk", "tjfx_qtqk", "tjfx_ssjb"] ->
        []
      page_type in ["cwzb_ylzl", "cwzb_gf", "cwzb_wbjm", "cwzb_bsjm", "cwzb_yj", "cwzb_wbzg", "cwzb_bszg", "tjfx_cfx", "cwzb_shbx", "cwzb_qt", "cwzb_zf", "cwzb_wbnc", "cwzb_bsnc", "cwzb_gl", "cwzb_hc", "cwzb_xy"] ->
        [%{en: "total", cn: "总数"}, %{en: "avg", cn: "平均"}, %{en: "rate", cn: "占比"}]
      page_type in ["jgjx_ylzl", "tjfx_mz", "tjfx_batj", "ylzl_gr", "cwzb_yl", "jgjx_yj", "jgjx_zzjh", "ylzl_yc", "ylzl_hl", "tjfx_blood", "ylzl_sx", "cwzb_sybx", "cwzb_pkjz", "tjfx_zdyj", "tjfx_xseqx", "tjfx_fh", "tjfx_fbbf", "tjfx_zlt0", "tjfx_zln0"] ->
        [%{en: "total", cn: "总数"}, %{en: "rate", cn: "占比"}]
      true -> []
    end
  end

  #由英文key获取中文key
  def cnkey(key) do
    case to_string(key) do
      "id" -> "ID"
      "org" -> "机构"
      "time" -> "时间"
      "int_time" -> "时间"
      "code" -> "编码"
      "version" -> "版本"
      "property" -> "类别"
      "option" -> "录入选项"
      "dissect" -> "解剖类型"
      "cc" -> "CC"
      "mcc" -> "MCC"
      "drg" -> "编码"
      "name" -> "名称"
      "drg2" -> "病种"
      "weight" -> "权重"
      "info_type" -> "类型"
      "death_level" -> "死亡风险等级"
      "day_avg" -> "平均住院天数"
      "num_num" -> "病历数"
      "num_sum" -> "病历数"
      "death_rate" -> "死亡率"
      "death_age_avg" -> "平均死亡年龄"
      #机构分析指标
      "weight_count" -> "总权重"
      "zdxg_num" -> "诊断相关组数"
      "day_index" -> "时间消耗指数"
      "fee_index" -> "费用消耗指数"
      "cmi" -> "CMI"
      "fee_avg" -> "平均住院费用"
      #医疗治疗指标
      "wlzl_num" -> "临床物理治疗病历数"
      "jrzl_num" -> "介入治疗病历数"
      "tszl_num" -> "特殊治疗病历数"
      "kfzl_num" -> "康复治疗病历数"
      "zyzl_num" -> "中医治疗病历数"
      "ybzl_num" -> "一般治疗病历数"
      "jszl_num" -> "精神治疗病历数"
      #医疗治疗占比指标
      "wlzl_rate" -> "临床物理治疗占比"
      "jrzl_rate" -> "介入治疗占比"
      "tszl_rate" -> "特殊治疗占比"
      "kfzl_rate" -> "康复治疗占比"
      "zyzl_rate" -> "中医治疗占比"
      "ybzl_rate" -> "一般治疗占比"
      "jszl_rate" -> "精神治疗占比"
      #重症监护室工作量指标
      "ccu_num" -> "心脏监护室（CCU）总人数"
      "ricu_num" -> "呼吸监护室（RICU）总人数"
      "sicu_num" -> "外科监护室（SICU）总人数"
      "nicu_num" -> "新生儿监护室（NICU）总人数"
      "picu_num" -> "儿科监护室（PICU）总人数"
      "other_num" -> "其他监护室总人数"
      #重症监护室工作量占比指标
      "ccu_rate" -> "心脏监护室（CCU）总人数占比"
      "ricu_rate" -> "呼吸监护室（RICU）总人数占比"
      "sicu_rate" -> "外科监护室（SICU）总人数占比"
      "nicu_rate" -> "新生儿监护室（NICU）总人数占比"
      "picu_rate" -> "儿科监护室（PICU）总人数占比"
      "other_rate" -> "其他监护室总人数占比"
      #床位指标
      "sjkfzc_num" -> "实际开放总床日数"
      "sjzyzc_num" -> "实际占用总床日数"
      "cyzzyzc_num" -> "出院者占用总床日数"
      "pjkfbc_num" -> "平均开放病床数"
      "bczz_num" -> "病床周转次数"
      "bcgzr_num" -> "病床工作日"
      "cyzpjzy_num" -> "出院者平均住院日"
      "bcsy_rate" -> "病床使用率"
      #医疗检查指标
      "ylsy_num" -> "医疗使用病历数"
      "zl_num" -> "诊疗病历数"
      "zl_rate" -> "诊疗占比"
      "jc_num" -> "一般检查病历数"
      "jc_rate" -> "一般检查占比"
      "js_num" -> "接生病历数"
      "js_rate" -> "接生占比"
      #医技工作量指标
      "yjsy_num" -> "医技使用病历数"
      "hsjc_num" -> "核素检查病历数"
      "hszl_num" -> "核素治疗病历数"
      "cszl_num" -> "超声治疗病历数"
      "fszl_num" -> "放射治疗病历数"
      "hy_num" -> "化验病历数"
      "bl_num" -> "病理病历数"
      #医技工作量占比指标
      "yjsy_rate" -> "医技使用病历数占比"
      # "hsjc_rate" -> "核素检查占比"
      # "hszl_rate" -> "核素治疗占比"
      "cszl_rate" -> "超声治疗占比"
      "fszl_rate" -> "放射治疗占比"
      "hy_rate" -> "化验占比"
      "bl_rate" -> "病理检验占比"
      #医技收入--总数
      "hsjc_expense" -> "核素检查费"
      "hszl_expense" -> "核素治疗费"
      "cs_expense" -> "超声费"
      "fs_expense" -> "放射费"
      "hy_expense" -> "化验费"
      "bl_expense" -> "病理费"
      #医技收入--平均
      "avg_hsjc" -> "例均核素检查费"
      "avg_hszl" -> "例均核素治疗费"
      "avg_cs" -> "例均超声费"
      "avg_fs" -> "例均放射费"
      "avg_hy" -> "例均化验费"
      "avg_bl" -> "例均病理费"
      #医技收入--占比
      "hsjc_rate" -> "核素检查费占比"
      "hszl_rate" -> "核素治疗费占比"
      "csf_rate" -> "超声费占比"
      "fsf_rate" -> "放射费占比"
      "hyf_rate" -> "化验费占比"
      "blf_rate" -> "病理费占比"
      #管理工作量指标
      "jhfz_num" -> "监护及辅助病历数"
      "jhfz_rate" -> "监护及辅助占比"
      "sx_num" -> "输血病历数"
      "sx_rate" -> "输血占比"
      "sy_num" -> "输氧使用病历数"
      "sy_rate" -> "输氧人数占比"
      #低风险组统计
      "dfx_num" -> "低风险组病历数"
      "dfxsw_num" -> "低风险组死亡人数"
      "dfxsw_rate" -> "低风险组死亡率"
      "dfx_age"-> "低风险平均死亡年龄"
      "ysj_num"-> "低风险组有尸检病历数"
      "wsj_num"-> "低风险组无尸检病历数"
      #中低风险组统计
      "zdfx_num" -> "中低风险组病历数"
      "zdfxsw_num" -> "中低风险组死亡人数"
      "zdfxsw_rate" -> "中低风险组死亡率"
      "zdfx_age"-> "中低风险平均死亡年龄"
      "zdysj_num"-> "中低风险组有尸检病历数"
      "zdwsj_num"-> "中低风险组无尸检病历数"
      #中高风险组统计
      "zgfx_num" -> "中高风险组病历数"
      "zgfxsw_num" -> "中高风险组死亡人数"
      "zgfxsw_rate" -> "中高风险组死亡率"
      "zgfx_age"-> "中高风险平均死亡年龄"
      "zgysj_num"-> "中高风险组有尸检病历数"
      "zgwsj_num"-> "中高风险组无尸检病历数"
      #高风险组统计
      "gfx_num" -> "高风险组病历数"
      "gfxsw_num" -> "高风险组死亡人数"
      "gfxsw_rate" -> "高风险组死亡率"
      "gfx_age"-> "高风险组死亡年龄"
      "gysj_num"-> "高风险组有尸检病历数"
      "gwsj_num"-> "高风险组无尸检病历数"
      #医疗费用指标
      "yl_expense" -> "医疗总费用"
      "zl_expense" -> "诊察（诊疗）费"
      "ybjc_expense" -> "一般检查费"
      "js_expense" -> "接生费"
      "mz_expense" -> "麻醉费"
      "ss_expense" -> "手术费"
      #例均医疗费用
      "avg_yl" -> "例均医疗费用"
      "avg_zl" -> "例均诊察(诊疗)费"
      "avg_ybjc" -> "例均一般检查费"
      "avg_js" -> "例均接生费"
      "avg_mz" -> "例均麻醉费"
      "avg_ss" -> "例均手术费"
      #医疗费用占比
      "yl_rate" -> "医疗费用占比"
      "zlf_rate" -> "诊察（诊疗）费占比"
      "ybjcf_rate" -> "一般检查费占比"
      "jsf_rate" -> "接生费占比"
      "mzf_rate" -> "麻醉费占比"
      "ssf_rate" -> "手术费占比"
      #医疗治疗费用
      "jrzl_expense" -> "介入治疗费"
      "tszl_expense" -> "特殊治疗费"
      "kfzl_expense" -> "康复治疗费"
      "zyzl_expense" -> "中医治疗费"
      "ybzl_expense" -> "一般治疗费"
      "jszl_expense" -> "精神治疗费"
      "wlzl_expense" -> "临床物理治疗费"
      #例均医疗治疗费用
      "avg_jrzl" -> "例均介入治疗费"
      "avg_tszl"-> "例均特殊治疗费"
      "avg_kfzl" -> "例均康复治疗费"
      "avg_zyzl" -> "例均中医治疗费"
      "avg_ybzl" -> "例均一般治疗费"
      "avg_jszl" -> "例均精神治疗费"
      "avg_wlzl" -> "例均临床物理治疗费"
      #医疗治疗费用占比
      "jrzlf_rate" -> "介入治疗费占比"
      "tszlf_rate" -> "特殊治疗费占比"
      "kfzlf_rate" -> "康复治疗费占比"
      "zyzlf_rate" -> "中医治疗费占比"
      "ybzlf_rate" -> "一般治疗费占比"
      "jszlf_rate" -> "精神治疗费占比"
      "wlzlf_rate" -> "临床物理治疗费占比"
      #管理费用指标
      "glze_expense" -> "管理总额"
      "jhfz_expense" -> "监护及辅助呼吸费"
      "cw_expense" -> "床位费"
      "gh_expense" -> "挂号费"
      "sy_expense" -> "输氧费"
      "other_expense" -> "其他费用"
      #例均管理费用
      "avg_glze" -> "例均管理总额"
      "avg_jhfz" -> "例均监护及辅助呼吸费"
      "avg_cw" -> "例均床位费"
      "avg_gh" -> "例均挂号费"
      "avg_sy" -> "例均输氧费"
      "avg_other" -> "例均其他费用"
      #管理总额占比
      "glze_rate" -> "管理总额占比"
      "jhfzf_rate" -> "监护及辅助呼吸费占比"
      "cwf_rate" -> "床位费占比"
      "ghf_rate" -> "挂号费占比"
      "syf_rate" -> "输氧费占比"
      "otherf_rate" -> "其他费用占比"
      #中药指标
      "zc_expense" -> "中成药费"
      "zcy_expense" -> "中草药费"
      "avg_zc" -> "例均中成药费"
      "avg_zcy" -> "例均中草药费"
      "zc_rate" -> "中成药费占比"
      "zcy_rate" -> "中草药费占比"
      #护理收入
      "hlze_num" -> "护理总额"
      "hlzl_num" -> "护理治疗费"
      "hlf_num" -> "护理费"
      "hlzl_avg" -> "例均护理总额"
      "hlf_avg" -> "例均护理治疗费"
      "hlze_rate" -> "护理总额占比"
      "hlzl_rate" -> "护理治疗费占比"
      "hlf_rate" -> "护理费占比"
      #西药制品费用
      "sx_expense" -> "输血费"
      "xy_expense" -> "西药费"
      "kjy_expense" -> "抗菌药物费"
      "bdb_expense" -> "白蛋白类制品费"
      "qdb_expense" -> "球蛋白类制品费"
      "nxyz_expense" -> "凝血因子类制品费"
      "xbyz_expense" -> "细胞因子类制品费"
      #例均西药费
      "avg_sxf" -> "例均输血费"
      "avg_xyf" -> "例均西药费"
      "avg_kjy" -> "例均抗菌药物费"
      "avg_bdb" -> "例均白蛋白类制品费"
      "avg_qdb" -> "例均球蛋白类制品费"
      "avg_nxyz" -> "例均凝血因子类制品费"
      "avg_xbyz" -> "例均细胞因子类制品费"
      #西药制品占比
      "sxf_rate" -> "输血费占比"
      "xyf_rate" -> "西药费占比"
      "kjy_rate" -> "抗菌药物费占比"
      "bdb_rate" -> "白蛋白类制品费占比"
      "qdb_rate" -> "球蛋白类制品费占比"
      "nxyz_rate" -> "凝血因子类制品费占比"
      "xbyz_rate" -> "细胞因子类制品费占比"
      #耗材成本
      "ypzef" -> "药品总额"
      "zlyc_expense" -> "治疗用一次性医用材料费"
      "jryc_expense" -> "介入用一次性医用材料费"
      "ssyc_expense" -> "手术用一次性医用材料费"
      "jcyc_expense" -> "检查用一次性医用材料费"
      "hc_expense" -> "耗材成本"
      #例均耗材费用
      "avg_yp" -> "例均药品费用"
      "avg_zlyc" -> "例均治疗用一次性医用材料费"
      "avg_jryc" -> "例均介入用一次性医用材料费"
      "avg_ssyc" -> "例均手术用一次性医用材料费"
      "avg_jcyc" -> "例均检查用一次性医用材料费"
      "avg_hc" -> "例均耗材成本"
      #耗材占比
      "yp_rate" -> "药品总额占比"
      "zlyc_rate" -> "治疗用一次性医用材料费占比"
      "jryc_rate" -> "介入用一次性医用材料费占比"
      "ssyc_rate" -> "手术用一次性医用材料费占比"
      "jcyc_rate" -> "检查用一次性医用材料费占比"
      "hc_rate" -> "耗材成本率"
      #重返率指标
      "is_inhosp31" -> "有出院31日再入院计划患者数"
      "inhosp_rate" -> "再住院计划患者率"
      "num_num1" -> "出院当天再入院人数"
      "num_rate1" -> "出院当天再入院率"
      "num_num2" -> "2-15再入院人数"
      "num_rate2" -> "2-15再入院率"
      "num_num3" -> "16-31再入院人数"
      "num_rate3" -> "16-31再入院人率"
      #离院情况统计
      "yzly_num" -> "医嘱离院患者总人数"
      "yzly_rate" -> "医嘱离院率"
      "yzzy_num" -> "医嘱转院患者总人数"
      "yzzy_rate" -> "医嘱转院率"
      "yzzsq_num" -> "医嘱转社区卫生服务机构/乡镇卫生院患者总人数"
      "yzzsq_rate" -> "医嘱转社区率"
      "fyzly_num" -> "非医嘱离院患者总人数"
      "fyzly_rate" -> "非医嘱离院率"
      #诊断符合率统计
      "rycyfh_num" -> "入院诊断与出院诊断符合人数"
      "rycyfh_rate" -> "入院诊断与出院诊断符合率"
      "zdblfh_num" -> "诊断与病理诊断符合人数"
      "zdblfh_rate" -> "诊断与病理诊断符合率"
      "ryssfh_num" -> "入院诊断与手术诊断符合人数"
      "ryssfh_rate" -> "入院诊断与手术诊断符合率"
      #护理类负性事件统计
      "num_num" -> "分析病历数"
      "hlfxsj_num" -> "护理负性事件患者总数"
      "syyw_num" -> "输液意外损伤人数"
      "syyl_num" -> "输液遗留体内异物人数"
      "syyf_num" -> "输液无菌预防措施的失败人数"
      "syry_num" -> "输液时溶液稀释不当人数"
      "sywr_num" -> "输液器械的污染人数"
      "sygl_num" -> "输液液体过量人数"
      #护理类负性事件占比
      "hlfxsj_rate" -> "护理负性事件患者总数占比"
      "syyw_rate" -> "输液意外损伤人数占比"
      "syyl_rate" -> "输液遗留体内异物人数占比"
      "syyf_rate" -> "输液无菌预防措施的失败人数占比"
      "syry_rate" -> "输液时溶液稀释不当人数占比"
      "sywr_rate" -> "输液器械的污染人数占比"
      "sygl_rate" -> "输液液体过量人数占比"
      #输血类负性事件统计
      # "num_num" -> "分析病历数"
      "sxfxsj_num" -> "输血负性事件患者总数"
      "sxyw_num" -> "输血意外损伤人数"
      "sxyl_num" -> "输血遗留体内异物人数"
      "sxyf_num" -> "输血无菌预防措施的失败人数"
      "sxwr_num" -> "输血器械的污染人数"
      "sxgl_num" -> "输血液体过量人数"
      #输血类负性事件占比
      "sxfxsj_rate" -> "输血负性事件患者总数占比"
      "sxyw_rate" -> "输血意外损伤人数占比"
      "sxyl_rate" -> "输血遗留体内异物人数占比"
      "sxyf_rate" -> "输血无菌预防措施的失败人数占比"
      "sxwr_rate" -> "输血器械的污染人数占比"
      "sxgl_rate" -> "输血液体过量人数占比"
      #压疮类负性事件统计
      # "num_num" -> "分析病历数"
      "ychz_num" -> "压疮患者总数"
      "odyc_num" -> "Ⅰ度压疮患者数"
      "wdyc_num" -> "Ⅱ度压疮患者数"
      "tdyc_num" -> "Ⅲ度压疮患者数"
      "fdyc_num" -> "Ⅳ度压疮患者数"
      #压疮类负性事件占比
      "ychz_rate" -> "压疮患者总数占比"
      "odyc_rate" -> "Ⅰ度压疮患者占比"
      "wdyc_rate" -> "Ⅱ度压疮患者占比"
      "tdyc_rate" -> "Ⅲ度压疮患者占比"
      "fdyc_rate" -> "Ⅳ度压疮患者占比"
      #跌倒、坠床类负性事件分析
      # "num_num" -> "分析病历数"
      "ywdd_num" -> "意外跌倒患者总数"
      "ycdd_rate" -> "意外跌倒患者总数占比"
      "zc_num" -> "坠床患者总数"
      # "zc_rate" -> "坠床患者总数占比"
      #药物类负性事件分析
      # "num_num" -> "分析病历数"f
      "ywfxsj_num" -> "药物负性事件患者总数"
      "ywfxsj_rate" -> "药物负性事件患者总数占比"
      "ywgl_num" -> "药物过量人数"
      "ywgl_rate" -> "药物过量占比"
      "ywgc_num" -> "药物给错总人数"
      "ywgc_rate" -> "药物给错总人数占比"
      #手术分析
      "sqday_num" -> "术前平均住院日"
      "shday_num" -> "术后平均住院日"
      "fjh_num" -> "非计划再次手术例数"
      "fjh_rate" -> "非计划再次手术例数占比"
      "zdss_num" -> "重点手术例数"
      "sw_num" -> "死亡例数"
      "sw_rate" -> "死亡例数占比"
      #手术类负性事件分析
      "qklk_num" -> "切口裂开患者总人数"
      "qklk_rate" -> "切口裂开患者总人数占比"
      "qkgr_num" -> "切口感染患者总人数"
      "qkgr_rate" -> "切口感染率总人数占比"
      "shgr_num" -> "术后感染例数"
      "shgr_rate" -> "术后感染例数占比"
      "shbf_num" -> "术后并发症例数"
      "shbf_rate" -> "术后并发症例数占比"
      #甲类切口统计
      "yjqk_num" -> "Ⅰ/甲切口愈合等级患者总人数"
      "yjqk_rate" -> "Ⅰ/甲切口愈合等级患者总人数占比"
      "ejqk_num" -> "Ⅱ/甲切切口愈合等级患者总人数"
      "ejqk_rate" -> "Ⅱ/甲切切口愈合等级患者总人数占比"
      "sjqk_num" -> "Ⅲ/甲切口愈合等级患者总人数"
      "sjqk_rate" -> "Ⅲ/甲切口愈合等级患者总人数占比"
      #其他切口统计
      "yss_num" -> "有手术，但体表无切口患者总人数"
      "yss_rate" -> "有手术，但体表无切口患者人数占比"
      "yjqtqk_num" -> "Ⅰ/其他切口愈合等级患者总人数"
      "yjqtqk_rate" -> "Ⅰ/其他切口愈合等级患者总人数占比"
      "ejqtqk_num" -> "Ⅱ/其他切口愈合等级患者总人数"
      "ejqtqk_rate" -> "Ⅱ/其他切口愈合等级患者总人数占比"
      "sjqtqk_num" -> "Ⅲ/其他切口愈合等级患者总人数"
      "sjqtqk_rate" -> "Ⅲ/其他切口愈合等级患者总人数占比"
      #乙类切口统计
      "yjyqk_num" -> "Ⅰ/乙切口愈合等级患者总人数"
      "yjyqk_rate" -> "Ⅰ/乙切口愈合等级患者总人数占比"
      "ejyqk_num" -> "Ⅱ/乙切切口愈合等级患者总人数"
      "ejyqk_rate" -> "Ⅱ/乙切切口愈合等级患者总人数占比"
      "sjyqk_num" -> "Ⅲ/乙切口愈合等级患者总人数"
      "sjyqk_rate" -> "Ⅲ/乙切口愈合等级患者总人数占比"
      #丙类切口统计
      "yjbqk_num" -> "Ⅰ/丙切口愈合等级患者总人数"
      "yjbqk_rate" -> "Ⅰ/丙切口愈合等级患者总人数占比"
      "ejbqk_num" -> "Ⅱ/丙切口愈合等级患者总人数"
      "ejbqk_rate" -> "Ⅱ/丙切口愈合等级患者总人数占比"
      "sjbqk_num" -> "Ⅲ/丙切口愈合等级患者总人数"
      "sjbqk_rate" -> "Ⅲ/丙切口愈合等级患者总人数占比"
      #手术级别统计
      "ojss_num" -> "一级手术患者总人数"
      "ojss_rate" -> "一级手术患者总人数占比"
      "wjss_num" -> "二级手术患者总人数"
      "wjss_rate" -> "二级手术患者总人数占比"
      "tjss_num" -> "三级手术患者总人数"
      "tjss_rate" -> "三级手术患者总人数占比"
      "fjss_num" -> "四级手术患者总人数"
      "fjss_rate" -> "四级手术患者总人数占比"
      #病案质量分析
      "bazlj_num" -> "病案质量为甲级病案总数"
      "bazlj_rate" -> "病案质量为甲级病案总数占比"
      "bazly_num" -> "病案质量为乙级病案总数"
      "bazly_rate" -> "病案质量为乙级病案总数占比"
      "bazlb_num" -> "病案质量为丙级病案总数"
      "bazlb_rate" -> "病案质量为丙级病案总数占比"
      #肿瘤患者T0期统计
      "tl_num" -> "肿瘤患者T0期总人数"
      "to_num" -> "肿瘤患者T1期总人数"
      "tw_num" -> "肿瘤患者T2期总人数"
      "tt_num" -> "肿瘤患者T3期总人数"
      "tf_num" -> "肿瘤患者T4期总人数"
      "wfpgyf_num" -> "肿瘤患者无法评估原发肿瘤大小总人数"
      #肿瘤患者T0期占比
      "tl_rate" -> "肿瘤患者T0期总人数占比"
      "to_rate" -> "肿瘤患者T1期总人数占比"
      "tw_rate" -> "肿瘤患者T2期总人数占比"
      "tt_rate" -> "肿瘤患者T3期总人数占比"
      "tf_rate" -> "肿瘤患者T4期总人数占比"
      "wfpgyf_rate" -> "肿瘤患者无法评估原发肿瘤大小总人数占比"
      #肿瘤患者N0期统计
      "nl_num" -> "肿瘤患者N0期总人数"
      "no_num" -> "肿瘤患者N1期总人数"
      "nw_num" -> "肿瘤患者N2期总人数"
      "nt_num" -> "肿瘤患者N3期总人数"
      "nf_num" -> "肿瘤患者N4期总人数"
      "wfpglb_num" -> "肿瘤患者无法评估区域淋巴结有无转移总人数"
      #肿瘤患者N0期占比
      "nl_rate" -> "肿瘤患者N0期总人数占比"
      "no_rate" -> "肿瘤患者N1期总人数占比"
      "nw_rate" -> "肿瘤患者N2期总人数占比"
      "nt_rate" -> "肿瘤患者N3期总人数占比"
      "nf_rate" -> "肿瘤患者N4期总人数占比"
      "wfpglb_rate" -> "肿瘤患者无法评估区域淋巴结有无转移总人数占比"
      #肿瘤患者M0期统计
      "ml_num" -> "肿瘤患者M0期总人数"
      "ml_rate" -> "肿瘤患者M0期总人数占比"
      "mo_num" -> "肿瘤患者M1期总人数"
      "mo_rate" -> "肿瘤患者M1期总人数占比"
      "wfpgyc_num" -> "肿瘤患者无法评估远处是否转移总人数"
      "wfpgyc_rate" -> "肿瘤患者无法评估远处是否转移总人数占比"
      #肿瘤患者来源统计
      "man_num" -> "男性患者"
      "man_rate" -> "男性患者占比"
      "woman_num" -> "女性患者"
      "woman_rate" -> "女性患者占比"
      "bd_num" -> "本地患者数"
      "bd_rate" -> "本地患者数占比"
      "wd_num" -> "外地患者数"
      "wd_rate" -> "外地患者数占比"
      #肿瘤发病部位统计
      "xhxt_num" -> "消化系统总人数"
      "sjxt_num" -> "神经系统总人数"
      "hxxt_num" -> "呼吸系统总人数"
      "xyxh_num" -> "血液循环系统总人数"
      "ydxt_num" -> "运动系统总人数"
      "nfm_num" -> "内分泌系统总人数"
      "mnxt_num" -> "泌尿系统总人数"
      "szxt_num" -> "生殖系统总人数"
      #肿瘤发病部位占比
      "xhxt_rate" -> "消化系统总人数占比"
      "sjxt_rate" -> "神经系统总人数占比"
      "hxxt_rate" -> "呼吸系统总人数占比"
      "xyxh_rate" -> "血液循环系统总人数占比"
      "ydxt_rate" -> "运动系统总人数占比"
      "nfm_rate" -> "内分泌系统总人数占比"
      "mnxt_rate" -> "泌尿系统总人数占比"
      "szxt_rate" -> "生殖系统总人数占比"
      #肿瘤分化统计
      "zlfq_num" -> "肿瘤分期不详患者总人数"
      "gfh_num" -> "高分化程度患者总人数"
      "zfh_num" -> "中分化程度患者总人数"
      "dfh_num" -> "低分化程度患者总人数"
      "wfh_num" -> "未分化程度患者总人数"
      "wqd_num" -> "未确定程度患者总人数"
      #肿瘤分化占比
      "zlfq_rate" -> "肿瘤分期不详患者总人数占比"
      "gfh_rate" -> "高分化程度患者总人数占比"
      "zfh_rate" -> "中分化程度患者总人数占比"
      "dfh_rate" -> "低分化程度患者总人数占比"
      "wfh_rate" -> "未分化程度患者总人数占比"
      "wqd_rate" -> "未确定程度患者总人数占比"
      #T、B细胞统计
      "txb_num" -> "T细胞程度患者总人数"
      "txb_rate" -> "T细胞程度患者总人数占比"
      "bxb_num" -> "B细胞程度患者总人数"
      "bxb_rate" -> "B细胞程度患者总人数占比"
      "ftfbxb_num" -> "非T-非B程度患者总人数"
      "ftfbxb_rate" -> "非T-非B程度患者总人数占比"
      "nk_num" -> "NK（自然杀伤）细胞程度患者总人数"
      "nk_rate" -> "NK（自然杀伤）细胞程度患者总人数占比"
      #肿瘤诊断依据统计
      "lczg_num" -> "临床诊断作为最高诊断依据患者总人数"
      "xxct_num" -> "X线、CT、超声波、内窥镜等诊断作为最高诊断依据患者总人数"
      "sszd_num" -> "手术诊断作为最高诊断依据患者总人数"
      "shmy_num" -> "生化、免疫诊断作为最高诊断依据患者总人数"
      "xbx_num" -> "细胞学、血片诊断作为最高诊断依据患者总人数"
      "bljf_num" -> "病理（继发）诊断作为最高诊断依据患者总人数"
      "blyf_num" -> "病理（原发）诊断作为最高诊断依据患者总人数"
      "sjybl_num" -> "尸检（有病理）诊断作为最高诊断依据患者总人数"
      "zgzdyj_num" -> "最高诊断依据不详患者总人数"
      #肿瘤诊断依据占比
      "lczg_rate" -> "临床诊断作为最高诊断依据患者总人数占比"
      "xxct_rate" -> "X线、CT、超声波、内窥镜等诊断作为最高诊断依据患者总人数占比"
      "sszd_rate" -> "手术诊断作为最高诊断依据患者总人数占比"
      "shmy_rate" -> "生化、免疫诊断作为最高诊断依据患者总人数占比"
      "xbx_rate" -> "细胞学、血片诊断作为最高诊断依据患者总人数占比"
      "bljf_rate" -> "病理（继发）诊断作为最高诊断依据患者总人数占比"
      "blyf_rate" -> "病理（原发）诊断作为最高诊断依据患者总人数占比"
      "sjybl_rate" -> "尸检（有病理）诊断作为最高诊断依据患者总人数占比"
      "zgzdyj_rate" -> "最高诊断依据不详患者总人数占比"
      #RH阴性患者统计
      "rhya_num" -> "RH阴性_A型血型患者总人数"
      "rhya_rate" -> "RH阴性_A型血型患者总人数占比"
      "rhyb_num" -> "RH阴性_B型血型患者总人数"
      "rhyb_rate" -> "RH阴性_B型血型患者总人数占比"
      "rhyo_num" -> "RH阴性_O型血型患者总人数"
      "rhyo_rate" -> "RH阴性_O型血型患者总人数占比"
      "rhyab_num" -> "RH阴性_AB型血型患者总人数"
      "rhyab_rate" -> "RH阴性_AB型血型患者总人数占比"
      #RH不详患者统计
      "rhbxa_num" -> "RH不详_A型血型患者总人数"
      "rhbxa_rate" -> "RH不详_A型血型患者总人数占比"
      "rhbxb_num" -> "RH不详_B型血型患者总人数"
      "rhbxb_rate" -> "RH不详_B型血型患者总人数占比"
      "rhbxo_num" -> "RH不详_O型血型患者总人数"
      "rhbxo_rate" -> "RH不详_O型血型患者总人数占比"
      "rhbxab_num" -> "RH不详_AB型血型患者总人数"
      "rhbxab_rate" -> "RH不详_AB型血型患者总人数占比"
      #RH阳性患者统计
      "rhyxa_num" -> "RH阳性_A型血型患者总人数"
      "rhyxa_rate" -> "RH阳性_A型血型患者总人数占比"
      "rhyxb_num" -> "RH阳性_B型血型患者总人数"
      "rhyxb_rate" -> "RH阳性_B型血型患者总人数占比"
      "rhyxo_num" -> "RH阳性_O型血型患者总人数"
      "rhyxo_rate" -> "RH阳性_O型血型患者总人数占比"
      "rhyxab_num" -> "RH阳性_AB型血型患者总人数"
      "rhyxab_rate" -> "RH阳性_AB型血型患者总人数占比"
      #Rh阳性全血使用统计
      "rhyxa_cc" -> "Rh阳性_A型血型使用总单位数"
      "rhyxb_cc" -> "Rh阳性_B型血型使用总单位数"
      "rhyxab_cc" -> "Rh阳性_AB型血型使用总单位数"
      "rhyxo_cc" -> "Rh阳性_O型血型使用总单位数"
      "rhyxacc_rate" -> "Rh阳性_A型血型使用总单位数占比"
      "rhyxbcc_rate" -> "Rh阳性_B型血型使用总单位数占比"
      "rhyxabcc_rate" -> "Rh阳性_AB型血型使用总单位数占比"
      "rhyx0cc_rate" -> "Rh阳性_O型血型使用总单位数占比"
      #Rh阴性全血使用统计
      "rhyacc_rate" -> "Rh阴性_A型血型使用总单位数占比"
      "rhybcc_rate" -> "Rh阴性_B型血型使用总单位数占比"
      "rhyabcc_rate" -> "Rh阴性_AB型血型使用总单位数占比"
      "rhy0cc_rate" -> "Rh阴性_O型血型使用总单位数占比"
      "rhya_cc" -> "Rh阴性_A型血型使用总单位数"
      "rhyb_cc" -> "Rh阴性_B型血型使用总单位数"
      "rhyab_cc" -> "Rh阴性_AB型血型使用总单位数"
      "rhyo_cc" -> "Rh阴性_O型血型使用总单位数"
       #成分血统计--总数
      # "num_num" -> "分析病历数"
      "cfx_num" -> "成分血总单位数"
      "hxb_num" -> "红细胞使用总单位数"
      "xsb_num" -> "血小板使用总单位数"
      "xj_num" -> "血浆使用总单位数"
      "qx_num" -> "全血使用总单位数"
      "qtx_num" -> "其它血制品使用总单位数"
      #成分血统计--平均
      # "num_num" -> "分析病历数"
      "cfx_avg" -> "例均成分血使用总单位数"
      "hxb_avg" -> "例均红细胞使用总单位数"
      "xsb_avg" -> "例均血小板使用总单位数"
      "xj_avg" -> "例均血浆使用总单位数"
      "qx_avg" -> "例均全血使用总单位数"
      "qtx_avg" -> "例均其它血制品使用总单位数"
      #成分血统计--占比
      "sum_rate" -> "分析病历数"
      "cfx_rate" -> "成分血总单位数占比"
      "hxb_rate" -> "红细胞使用总单位数占比"
      "xsb_rate" -> "血小板使用总单位数占比"
      "xj_rate" -> "血浆使用总单位数占比"
      "qx_rate" -> "全血使用总单位数占比"
      "qtx_rate" -> "其它血制品使用总单位数占比"
      #本市城镇职工基本医疗保险患者支付统计--总数
      "bszg_num" -> "本市城镇职工基本医疗保险患者支付总额"
      "bszgzf_num" -> "本市城镇职工基本医疗保险患者自付总额"
      "bszgyl_num" -> "本市城镇职工基本医疗保险患者医疗总额"
      "bszgyj_num" -> "本市城镇职工基本医疗保险患者医技总额"
      "bszgypj_num" -> "本市城镇职工基本医疗保险患者药品总额"
      "bszghl_num" -> "本市城镇职工基本医疗保险患者护理总额"
      "bszggl_num" -> "本市城镇职工基本医疗保险患者管理总额"
      #本市城镇职工基本医疗保险患者支付统计--平均
      "bszg_avg" -> "本市城镇职工基本医疗保险患者例均支付总额"
      "bszgzf_avg" -> "本市城镇职工基本医疗保险患者例均自付总额"
      "bszgyl_avg" -> "本市城镇职工基本医疗保险患者例均医疗总额"
      "bszgyj_avg" -> "本市城镇职工基本医疗保险患者例均医技总额"
      "bszgypj_avg" -> "本市城镇职工基本医疗保险患者例均药品总额"
      "bszghl_avg" -> "本市城镇职工基本医疗保险患者例均护理总额"
      "bszggl_avg" -> "本市城镇职工基本医疗保险患者例均管理总额"
      #本市城镇职工基本医疗保险患者支付统计--占比
      "bszg_rate" -> "本市城镇职工基本医疗保险患者支付总额占比"
      "bszgzf_rate" -> "本市城镇职工基本医疗保险患者自付总额占比"
      "bszgyl_rate" -> "本市城镇职工基本医疗保险患者医疗总额占比"
      "bszgyj_rate" -> "本市城镇职工基本医疗保险患者医技总额占比"
      "bszgypj_rate" -> "本市城镇职工基本医疗保险患者药品总额占比"
      "bszghl_rate" -> "本市城镇职工基本医疗保险患者护理总额占比"
      "bszggl_rate" -> "本市城镇职工基本医疗保险患者管理总额占比"
      #外埠城镇职工基本医疗保险患者支付统计--总数
      "wbzg_num" -> "外埠城镇职工基本医疗保险患者支付总额"
      "wbzgzf_num" -> "外埠城镇职工基本医疗保险患者自付总额"
      "wbzgyl_num" -> "外埠城镇职工基本医疗保险患者医疗总额"
      "wbzgyj_num" -> "外埠城镇职工基本医疗保险患者医技总额"
      "wbzgypj_num" -> "外埠城镇职工基本医疗保险患者药品总额"
      "wbzghl_num" -> "外埠城镇职工基本医疗保险患者护理总额"
      "wbzggl_num" -> "外埠城镇职工基本医疗保险患者管理总额"
      #外埠城镇职工基本医疗保险患者支付统计--平均
      "wbzg_avg" -> "外埠城镇职工基本医疗保险患者例均支付总额"
      "wbzgzf_avg" -> "外埠城镇职工基本医疗保险患者例均自付总额"
      "wbzgyl_avg" -> "外埠城镇职工基本医疗保险患者例均医疗总额"
      "wbzgyj_avg" -> "外埠城镇职工基本医疗保险患者例均医技总额"
      "wbzgypj_avg" -> "外埠城镇职工基本医疗保险患者例均药品总额"
      "wbzghl_avg" -> "外埠城镇职工基本医疗保险患者例均护理总额"
      "wbzggl_avg" -> "外埠城镇职工基本医疗保险患者例均管理总额"
      #外埠城镇职工基本医疗保险患者支付统计--占比
      "wbzg_rate" -> "外埠城镇职工基本医疗保险患者支付总额占比"
      "wbzgzf_rate" -> "外埠城镇职工基本医疗保险患者自付总额占比"
      "wbzgyl_rate" -> "外埠城镇职工基本医疗保险患者医疗总额占比"
      "wbzgyj_rate" -> "外埠城镇职工基本医疗保险患者医技总额占比"
      "wbzgypj_rate" -> "外埠城镇职工基本医疗保险患者药品总额占比"
      "wbzghl_rate" -> "外埠城镇职工基本医疗保险患者护理总额占比"
      "wbzggl_rate" -> "外埠城镇职工基本医疗保险患者管理总额占比"
      #本市城镇居民基本医疗保险患者支付统计--总数
      "bsjm_num" -> "本市城镇居民基本医疗保险患者支付总额"
      "bsjmzf_num" -> "本市城镇居民基本医疗保险患者自付总额"
      "bsjmyl_num" -> "本市城镇居民基本医疗保险患者医疗总额"
      "bsjmyj_num" -> "本市城镇居民基本医疗保险患者医技总额"
      "bsjmypj_num" -> "本市城镇居民基本医疗保险患者药品总额"
      "bsjmhl_num" -> "本市城镇居民基本医疗保险患者护理总额"
      "bsjmgl_num" -> "本市城镇居民基本医疗保险患者管理总额"
      #本市城镇居民基本医疗保险患者支付统计--平均
      "bsjm_avg" -> "本市城镇居民基本医疗保险患者例均支付总额"
      "bsjmzf_avg" -> "本市城镇居民基本医疗保险患者例均自付总额"
      "bsjmyl_avg" -> "本市城镇居民基本医疗保险患者例均医疗总额"
      "bsjmyj_avg" -> "本市城镇居民基本医疗保险患者例均医技总额"
      "bsjmypj_avg" -> "本市城镇居民基本医疗保险患者例均药品总额"
      "bsjmhl_avg" -> "本市城镇居民基本医疗保险患者例均护理总额"
      "bsjmgl_avg" -> "本市城镇居民基本医疗保险患者例均管理总额"
      #本市城镇居民基本医疗保险患者支付统计--占比
      "bsjm_rate" -> "本市城镇居民基本医疗保险患者支付总额占比"
      "bsjmzf_rate" -> "本市城镇居民基本医疗保险患者自付总额占比"
      "bsjmyl_rate" -> "本市城镇居民基本医疗保险患者医疗总额占比"
      "bsjmyj_rate" -> "本市城镇居民基本医疗保险患者医技总额占比"
      "bsjmypj_rate" -> "本市城镇居民基本医疗保险患者药品总额占比"
      "bsjmhl_rate" -> "本市城镇居民基本医疗保险患者护理总额占比"
      "bsjmgl_rate" -> "本市城镇居民基本医疗保险患者管理总额占比"
      #外埠城镇居民基本医疗保险患者支付统计--总数
      "wbjm_num" -> "外埠城镇居民基本医疗保险患者支付总额"
      "wbjmzf_num" -> "外埠城镇居民基本医疗保险患者自付总额"
      "wbjmyl_num" -> "外埠城镇居民基本医疗保险患者医疗总额"
      "wbjmyj_num" -> "外埠城镇居民基本医疗保险患者医技总额"
      "wbjmypj_num" -> "外埠城镇居民基本医疗保险患者药品总额"
      "wbjmhl_num" -> "外埠城镇居民基本医疗保险患者护理总额"
      "wbjmgl_num" -> "外埠城镇居民基本医疗保险患者管理总额"
      #外埠城镇居民基本医疗保险患者支付统计--平均
      "wbjm_avg" -> "外埠城镇居民基本医疗保险患者例均支付总额"
      "wbjmzf_avg" -> "外埠城镇居民基本医疗保险患者例均自付总额"
      "wbjmyl_avg" -> "外埠城镇居民基本医疗保险患者例均医疗总额"
      "wbjmyj_avg" -> "外埠城镇居民基本医疗保险患者例均医技总额"
      "wbjmypj_avg" -> "外埠城镇居民基本医疗保险患者例均药品总额"
      "wbjmhl_avg" -> "外埠城镇居民基本医疗保险患者例均护理总额"
      "wbjmgl_avg" -> "外埠城镇居民基本医疗保险患者例均管理总额"
      #外埠城镇居民基本医疗保险患者支付统计--占比
      "wbjm_rate" -> "外埠城镇居民基本医疗保险患者支付总额占比"
      "wbjmzf_rate" -> "外埠城镇居民基本医疗保险患者自付总额占比"
      "wbjmyl_rate" -> "外埠城镇居民基本医疗保险患者医疗总额占比"
      "wbjmyj_rate" -> "外埠城镇居民基本医疗保险患者医技总额占比"
      "wbjmypj_rate" -> "外埠城镇居民基本医疗保险患者药品总额占比"
      "wbjmhl_rate" -> "外埠城镇居民基本医疗保险患者护理总额占比"
      "wbjmgl_rate" -> "外埠城镇居民基本医疗保险患者管理总额占比"
      #本市新型农村合作医疗患者支付统计--总数
      "bsxnh_num" -> "本市新型农村合作医疗患者支付总额"
      "bsxnhzf_num" -> "本市新型农村合作医疗患者自付总额"
      "bsxnhyl_num" -> "本市新型农村合作医疗患者医疗总额"
      "bsxnhyj_num" -> "本市新型农村合作医疗患者医技总额"
      "bsxnhypj_num" -> "本市新型农村合作医疗患者药品总额"
      "bsxnhhl_num" -> "本市新型农村合作医疗患者护理总额"
      "bsxnhgl_num" -> "本市新型农村合作医疗患者管理总额"
      #本市新型农村合作医疗患者支付统计--平均
      "bsxnh_avg" -> "本市新型农村合作医疗患者例均支付总额"
      "bsxnhzf_avg" -> "本市新型农村合作医疗患者例均自付总额"
      "bsxnhyl_avg" -> "本市新型农村合作医疗患者例均医疗总额"
      "bsxnhyj_avg" -> "本市新型农村合作医疗患者例均医技总额"
      "bsxnhypj_avg" -> "本市新型农村合作医疗患者例均药品总额"
      "bsxnhhl_avg" -> "本市新型农村合作医疗患者例均护理总额"
      "bsxnhgl_avg" -> "本市新型农村合作医疗患者例均管理总额"
      #本市新型农村合作医疗患者支付统计--占比
      "bsxnh_rate" -> "本市新型农村合作医疗患者支付总额占比"
      "bsxnhzf_rate" -> "本市新型农村合作医疗患者自付总额占比"
      "bsxnhyl_rate" -> "本市新型农村合作医疗患者医疗总额占比"
      "bsxnhyj_rate" -> "本市新型农村合作医疗患者医技总额占比"
      "bsxnhypj_rate" -> "本市新型农村合作医疗患者药品总额占比"
      "bsxnhhl_rate" -> "本市新型农村合作医疗患者护理总额占比"
      "bsxnhgl_rate" -> "本市新型农村合作医疗患者管理总额占比"
      #外埠新型农村合作医疗患者支付统计--总数
      "wbxnh_num" -> "外埠新型农村合作医疗患者支付总额"
      "wbxnhzf_num" -> "外埠新型农村合作医疗患者自付总额"
      "wbxnhyl_num" -> "外埠新型农村合作医疗患者医疗总额"
      "wbxnhyj_num" -> "外埠新型农村合作医疗患者医技总额"
      "wbxnhypj_num" -> "外埠新型农村合作医疗患者药品总额"
      "wbxnhhl_num" -> "外埠新型农村合作医疗患者护理总额"
      "wbxnhgl_num" -> "外埠新型农村合作医疗患者管理总额"
      #外埠新型农村合作医疗患者支付统计--平均
      "wbxnh_avg" -> "外埠新型农村合作医疗患者例均支付总额"
      "wbxnhzf_avg" -> "外埠新型农村合作医疗患者例均自付总额"
      "wbxnhyl_avg" -> "外埠新型农村合作医疗患者例均医疗总额"
      "wbxnhyj_avg" -> "外埠新型农村合作医疗患者例均医技总额"
      "wbxnhypj_avg" -> "外埠新型农村合作医疗患者例均药品总额"
      "wbxnhhl_avg" -> "外埠新型农村合作医疗患者例均护理总额"
      "wbxnhgl_avg" -> "外埠新型农村合作医疗患者例均管理总额"
      #外埠新型农村合作医疗患者支付统计--占比
      "wbxnh_rate" -> "外埠新型农村合作医疗患者支付总额占比"
      "wbxnhzf_rate" -> "外埠新型农村合作医疗患者自付总额占比"
      "wbxnhyl_rate" -> "外埠新型农村合作医疗患者医疗总额占比"
      "wbxnhyj_rate" -> "外埠新型农村合作医疗患者医技总额占比"
      "wbxnhypj_rate" -> "外埠新型农村合作医疗患者药品总额占比"
      "wbxnhhl_rate" -> "外埠新型农村合作医疗患者护理总额占比"
      "wbxnhgl_rate" -> "外埠新型农村合作医疗患者管理总额占比"
      #贫困救助患者支付统计--总数
      "pkjz_num" -> "贫困救助患者支付总额"
      "pkjzzf_num" -> "贫困救助患者自付总额"
      "pkjzyl_num" -> "贫困救助医疗总额"
      "pkjzyj_num" -> "贫困救助医技总额"
      "pkjzypj_num" -> "贫困救助药品总额"
      "pkjzhl_num" -> "贫困救助护理总额"
      "pkjzgl_num" -> "贫困救助管理总额"
      #贫困救助患者支付统计--平均
      "pkjz_avg" -> "贫困救助患者例均支付总额"
      "pkjzzf_avg" -> "贫困救助患者例均自付总额"
      "pkjzyl_avg" -> "贫困救助例均医疗总额"
      "pkjzyj_avg" -> "贫困救助例均医技总额"
      "pkjzypj_avg" -> "贫困救助例均药品总额"
      "pkjzhl_avg" -> "贫困救助例均护理总额"
      "pkjzgl_avg" -> "贫困救助例均管理总额"
      #贫困救助患者支付统计--占比
      "pkjz_rate" -> "贫困救助患者支付总额占比"
      "pkjzzf_rate" -> "贫困救助患者自付总额占比"
      "pkjzyl_rate" -> "贫困救助医疗总额占比"
      "pkjzyj_rate" -> "贫困救助医技总额占比"
      "pkjzypj_rate" -> "贫困救助药品总额占比"
      "pkjzhl_rate" -> "贫困救助护理总额占比"
      "pkjzgl_rate" -> "贫困救助管理总额占比"
      #商业医疗保险患者支付统计--总数
      "sybx_num" -> "商业医疗保险患者支付总额"
      "sybxzf_num" -> "商业医疗保险患者自付总额"
      "sybxyl_num" -> "商业医疗保险患者医疗总额"
      "sybxyj_num" -> "商业医疗保险患者医技总额"
      "sybxypj_num" -> "商业医疗保险患者药品总额"
      "sybxhl_num" -> "商业医疗保险患者护理总额"
      "sybxgl_num" -> "商业医疗保险患者管理总额"
      #商业医疗保险患者支付统计--平均
      "sybx_avg" -> "商业医疗保险患者例均支付总额"
      "sybxzf_avg" -> "商业医疗保险患者例均自付总额"
      "sybxyl_avg" -> "商业医疗保险患者例均医疗总额"
      "sybxyj_avg" -> "商业医疗保险患者例均医技总额"
      "sybxypj_avg" -> "商业医疗保险患者例均药品总额"
      "sybxhl_avg" -> "商业医疗保险患者例均护理总额"
      "sybxgl_avg" -> "商业医疗保险患者例均管理总额"
      #商业医疗保险患者支付统计--占比
      "sybx_rate" -> "商业医疗保险患者支付总额占比"
      "sybxzf_rate" -> "商业医疗保险患者自付总额占比"
      "sybxyl_rate" -> "商业医疗保险患者医疗总额占比"
      "sybxyj_rate" -> "商业医疗保险患者医技总额占比"
      "sybxypj_rate" -> "商业医疗保险患者药品总额占比"
      "sybxhl_rate" -> "商业医疗保险患者护理总额占比"
      "sybxgl_rate" -> "商业医疗保险患者管理总额占比"
      #全公费患者支付统计--总数
      "qgf_num" -> "全公费患者支付总额"
      "qgfzf_num" -> "全公费患者自付总额"
      "qgfyl_num" -> "全公费患者医疗总额"
      "qgfyj_num" -> "全公费患者医技总额"
      "qgfypj_num" -> "全公费患者药品总额"
      "qgfhl_num" -> "全公费患者护理总额"
      "qgfgl_num" -> "全公费患者管理总额"
      #全公费患者支付统计--平均
      "qgf_avg" -> "全公费患者例均支付总额"
      "qgfzf_avg" -> "全公费患者例均自付总额"
      "qgfyl_avg" -> "全公费患者例均医疗总额"
      "qgfyj_avg" -> "全公费患者例均医技总额"
      "qgfypj_avg" -> "全公费患者例均药品总额"
      "qgfhl_avg" -> "全公费患者例均护理总额"
      "qgfgl_avg" -> "全公费患者例均管理总额"
      #全公费患者支付统计--占比
      "qgf_rate" -> "全公费患者支付总额占比"
      "qgfzf_rate" -> "全公费患者自付总额占比"
      "qgfyl_rate" -> "全公费患者医疗总额占比"
      "qgfyj_rate" -> "全公费患者医技总额占比"
      "qgfypj_rate" -> "全公费患者药品总额占比"
      "qgfhl_rate" -> "全公费患者护理总额占比"
      "qgfgl_rate" -> "全公费患者管理总额占比"
      #全自费患者支付统计--总数
      "qzf_num" -> "全自费患者支付总额"
      "qzfyl_num" -> "全自费患者医疗总额"
      "qzfyj_num" -> "全自费患者医技总额"
      "qzfypj_num" -> "全自费患者药品总额"
      "qzfhl_num" -> "全自费患者护理总额"
      "qzfgl_num" -> "全自费患者管理总额"
      #全自费患者支付统计--平均
      "qzf_avg" -> "全自费患者例均支付总额"
      "qzfyl_avg" -> "全自费患者例均医疗总额"
      "qzfyj_avg" -> "全自费患者例均医技总额"
      "qzfypj_avg" -> "全自费患者例均药品总额"
      "qzfhl_avg" -> "全自费患者例均护理总额"
      "qzfgl_avg" -> "全自费患者例均管理总额"
      #全自费患者支付统计--占比
      "qzf_rate" -> "全自费患者支付总额占比"
      "qzfyl_rate" -> "全自费患者医疗总额占比"
      "qzfyj_rate" -> "全自费患者医技总额占比"
      "qzfypj_rate" -> "全自费患者药品总额占比"
      "qzfhl_rate" -> "全自费患者护理总额占比"
      "qzfgl_rate" -> "全自费患者管理总额占比"
      #其他社会保险患者支付统计--总数
      "qtbx_num" -> "其他社会保险患者支付总额"
      "qtbxzf_num" -> "其他社会保险患者自付总额"
      "qtbxyl_num" -> "其他社会保险医疗总额"
      "qtbxyj_num" -> "其他社会保险医技总额"
      "qtbxypj_num" -> "其他社会保险药品总额"
      "qtbxhl_num" -> "其他社会保险护理总额"
      "qtbxgl_num" -> "其他社会保险管理总额"
      #其他社会保险患者支付统计--平均
      "qtbx_avg" -> "其他社会保险患者例均支付总额"
      "qtbxzf_avg" -> "其他社会保险患者例均自付总额"
      "qtbxyl_avg" -> "其他社会保险例均医疗总额"
      "qtbxyj_avg" -> "其他社会保险例均医技总额"
      "qtbxypj_avg" -> "其他社会保险例均药品总额"
      "qtbxhl_avg" -> "其他社会保险例均护理总额"
      "qtbxgl_avg" -> "其他社会保险例均管理总额"
      #其他社会保险患者支付统计--占比
      "qtbx_rate" -> "其他社会保险患者支付总额占比"
      "qtbxzf_rate" -> "其他社会保险患者自付总额占比"
      "qtbxyl_rate" -> "其他社会保险医疗总额占比"
      "qtbxyj_rate" -> "其他社会保险医技总额占比"
      "qtbxypj_rate" -> "其他社会保险药品总额占比"
      "qtbxhl_rate" -> "其他社会保险护理总额占比"
      "qtbxgl_rate" -> "其他社会保险管理总额占比"
      #其他患者支付统计--总数
      "qthz_num" -> "其他患者支付总额"
      "qthzzf_num" -> "其他患者自付总额"
      "qthzyl_num" -> "其他患者医疗总额"
      "qthzyj_num" -> "其他患者医技总额"
      "qthzypj_num" -> "其他患者药品总额"
      "qthzhl_num" -> "其他患者护理总额"
      "qthzgl_num" -> "其他患者管理总额"
      #其他患者支付统计--平均
      "qthz_avg" -> "其他患者例均支付总额"
      "qthzzf_avg" -> "其他患者例均自付总额"
      "qthzyl_avg" -> "其他患者例均医疗总额"
      "qthzyj_avg" -> "其他患者例均医技总额"
      "qthzypj_avg" -> "其他患者例均药品总额"
      "qthzhl_avg" -> "其他患者例均护理总额"
      "qthzgl_avg" -> "其他患者例均管理总额"
      #其他患者支付统计--占比
      "qthz_rate" -> "其他患者支付总额占比"
      "qthzzf_rate" -> "其他患者自付总额占比"
      "qthzyl_rate" -> "其他患者医疗总额占比"
      "qthzyj_rate" -> "其他患者医技总额占比"
      "qthzypj_rate" -> "其他患者药品总额占比"
      "qthzhl_rate" -> "其他患者护理总额占比"
      "qthzgl_rate" -> "其他患者管理总额占比"
      #术中负性事件--总数
      "ssywss_num" -> "手术中意外损伤"
      "ssywqg_num" -> "手术中意外切割"
      "ssywzc_num" -> "手术中意外针刺"
      "ssywck_num" -> "手术中意外穿孔"
      "ssywcx_num" -> "手术中意外出血"
      "ssylyw_num" -> "手术中体内遗留异物"
      "sswjsb_num" -> "手术中无菌预防措施的失败"
      "ssczbd_num" -> "手术中操作不当"
      #术中负性事件--占比
      "ssywss_rate" -> "手术中意外损伤占比"
      "ssywqg_rate" -> "手术中意外切割占比"
      "ssywzc_rate" -> "手术中意外针刺占比"
      "ssywck_rate" -> "手术中意外穿孔占比"
      "ssywcx_rate" -> "手术中意外出血占比"
      "ssylyw_rate" -> "手术中体内遗留异物占比"
      "sswjsb_rate" -> "手术中无菌预防措施的失败占比"
      "ssczbd_rate" -> "手术中操作不当"
      #治疗--总数
      "zlywzl_num" -> "治疗中意外损伤"
      "zlywqg_num" -> "治疗中意外切割"
      "zlywzc_num" -> "治疗中意外针刺"
      "zlywck_num" -> "治疗中意外穿孔"
      "zlywcx_num" -> "治疗中意外出血"
      "zlylyw_num" -> "治疗中体内遗留异物"
      "zlwjsb_num" -> "治疗中无菌预防措施的失败"
      "zlczbd_num" -> "治疗中操作不当"
      #治疗--占比
      "zlywzl_rate" -> "治疗中意外损伤占比"
      "zlywqg_rate" -> "治疗中意外切割占比"
      "zlywzc_rate" -> "治疗中意外针刺占比"
      "zlywck_rate" -> "治疗中意外穿孔占比"
      "zlywcx_rate" -> "治疗中意外出血占比"
      "zlylyw_rate" -> "治疗中体内遗留异物占比"
      "zlwjsb_rate" -> "治疗中无菌预防措施的失败占比"
      "zlczbd_rate" -> "治疗中操作不当"
      #感染--总数
      "szh_num" -> "输注后感染"
      "czh_num" -> "操作后伤口感染"
      "ssh_num" -> "手术后切口感染"
      "stx_num" -> "肾透析感染"
      "rgjt_num" -> "人工假体植入感染"
      "ylqj_num" -> "医疗器具感染"
      #感染--占比
      "szh_rate" -> "输注后感染占比"
      "czh_rate" -> "操作后伤口感染占比"
      "ssh_rate" -> "手术后切口感染占比"
      "stx_rate" -> "肾透析感染占比"
      "rgjt_rate" -> "人工假体植入感染占比"
      "ylqj_rate" -> "医疗器具感染占比"
      #病案统计--总数
      # "num_num" -> "分析病历数"
      "ssls_num" -> "手术例数"
      "mzzy_num" -> "门诊住院病历数"
      "jzzy_num" -> "急诊住院病历数"
      "ybzf_num" -> "本市医保支付病历数"
      "xnh_num" -> "本市新农合支付病历数"
      "qzfbl_num" -> "全自费病历数"
      "qgfbl_num" -> "全公费病历数"
      #病案统计--占比
      "ssls_rate" -> "手术例数占比"
      "mzzy_rate" -> "门诊住院病历数占比"
      "jzzy_rate" -> "急诊住院病历数占比"
      "ybzf_rate" -> "医保支付病历数占比"
      "xnh_rate" -> "本市新农合支付病历数占比"
      "qzfbl_rate" -> "全自费病历数占比"
      "qgfbl_rate" -> "全公费病历数占比"
      #DRG病案入组统计
      "hos_num" -> "病例总数"
      "pc_num" -> "排除病例数"
      "wrmdc_num" -> "未入MDC病例数"
      "wrz_num" -> "未入组病例数"
      "qy_num" -> "QY病例数"
      "drg_rate" -> "入组率"
      # "num_num" -> "分析病历数"
      #血型统计--总数
      "blood_num" -> "输血总人数"
      "ablood_num" -> "A型血型患者总人数"
      "bblood_num" -> "B型血型患者总人数"
      "abblood_num" -> "AB型血型患者总人数"
      "oblood_num" -> "O型血型患者总人数"
      "wcblood_num" -> "未查血型患者总人数"
      #血型统计--占比
      "blood_rate" -> "输血人数占比"
      "ablood_rate" -> "A型血型患者人数占比"
      "bblood_rate" -> "B型血型患者人数占比"
      "abblood_rate" -> "AB型血型患者人数占比"
      "oblood_rate" -> "O型血型患者人数占比"
      "wcblood_rate" -> "未查血型患者人数占比"
      #麻醉人数统计--总数
      "mz_num" -> "麻醉总人数"
      "wmz_num" -> "有手术无麻醉患者总人数"
      "qsmz_num" -> "全身麻醉患者总人数"
      "xrmz_num" -> "吸入麻醉（气管内插管、喉罩、面罩）患者总人数"
      "jmmz_num" -> "静脉麻醉（全凭静脉麻醉）患者总人数"
      "jcmz_num" -> "基础麻醉（直肠注入、肌肉注射）患者总人数"
      "qymz_num" -> "区域麻醉患者总人数"
      "zgnmz_num" -> "椎管内麻醉患者总人数"
      #麻醉人数统计--占比
      "mz_rate" -> "麻醉人数占比"
      "wmz_rate" -> "有手术无麻醉患者总人数占比"
      "qsmz_rate" -> "全身麻醉患者总人数占比"
      "xrmz_rate" -> "吸入麻醉（气管内插管、喉罩、面罩）患者总人数占比"
      "jmmz_rate" -> "静脉麻醉（全凭静脉麻醉）患者总人数占比"
      "jcmz_rate" -> "基础麻醉（直肠注入、肌肉注射）患者总人数占比"
      "qymz_rate" -> "区域麻醉患者总人数占比"
      "zgnmz_rate" -> "椎管内麻醉患者总人数占比"
      #复合麻醉患者统计--总数
      "ymwfh_num" -> "蛛网膜下-硬膜外复合麻醉患者总人数"
      "fhmz_num" -> "复合麻醉患者总人数"
      "btywfh_num" -> "不同药物的复合：普鲁卡因静脉复合全麻，神经安定镇痛麻醉等患者总人数"
      "btfffh_num" -> "不同方法的复合：静吸复合全麻，针药复合麻醉，全身-硬膜外复合麻醉，脊髓-硬膜外复合麻醉等患者总人数"
      "tsfffh_num" -> "特殊方法的复合：全麻复合全身降温（低温麻醉）， 控制性降压等患者总人数"
      "jxfh_num" -> "静吸复合麻醉患者总人数"
      "qtmz_num" -> "其他麻醉患者总人数"
      #复合麻醉患者统计--占比
      "ymwfh_rate" -> "蛛网膜下-硬膜外复合麻醉患者总人数占比"
      "fhmz_rate" -> "复合麻醉患者总人数占比"
      "btywfh_rate" -> "不同药物的复合：普鲁卡因静脉复合全麻，神经安定镇痛麻醉等患者总人数占比"
      "btfffh_rate" -> "不同方法的复合：静吸复合全麻，针药复合麻醉，全身-硬膜外复合麻醉，脊髓-硬膜外复合麻醉等患者总人数占比"
      "tsfffh_rate" -> "特殊方法的复合：全麻复合全身降温（低温麻醉）， 控制性降压等患者总人数占比"
      "jxfh_rate" -> "静吸复合麻醉患者总人数占比"
      "qtmz_rate" -> "其他麻醉患者总人数占比"
      #其他阻滞麻醉统计
      "zwmx_num" -> "蛛网膜下腔阻滞患者总人数"
      "zwmx_rate" -> "蛛网膜下腔阻滞患者总人数占比"
      "ymw_num" -> "硬膜外间隙阻滞（含骶管阻滞）患者总人数"
      "ymw_rate" -> "硬膜外间隙阻滞（含骶管阻滞）患者总人数占比"
      # "jc_num" -> "颈丛阻滞患者总人数"
      # "jc_rate" -> "颈丛阻滞患者总人数占比"
      "sj_num" -> "神经及神经丛阻滞患者总人数"
      "sj_rate" -> "神经及神经丛阻滞患者总人数占比"
      #神经阻滞麻醉统计--总数
      "bc_num" -> "臂丛阻滞及上肢神经阻滞患者总人数"
      "yz_num" -> "腰骶神经丛阻滞及下肢神经阻滞患者总人数"
      "qg_num" -> "躯干神经阻滞：肋间神经阻滞患者总人数"
      "zp_num" -> "椎旁神经阻滞患者总人数"
      "per_num" -> "会阴神经阻滞患者总人数"
      "jg_num" -> "交感神经阻滞：星状神经节阻滞患者总人数"
      "xy_num" -> "胸腰交感神经阻滞患者总人数"
      "n_num" -> "脑神经阻滞：三叉神经阻滞、舌咽神经阻滞患者总人数"
      #神经阻滞麻醉统计--占比
      "bc_rate" -> "臂丛阻滞及上肢神经阻滞患者总人数占比"
      "yz_rate" -> "腰骶神经丛阻滞及下肢神经阻滞患者总人数占比"
      "qg_rate" -> "躯干神经阻滞：肋间神经阻滞患者总人数占比"
      "zp_rate" -> "椎旁神经阻滞患者总人数占比"
      "per_rate" -> "会阴神经阻滞患者总人数占比"
      "jg_rate" -> "交感神经阻滞：星状神经节阻滞患者总人数占比"
      "xy_rate" -> "胸腰交感神经阻滞患者总人数占比"
      "n_rate" -> "脑神经阻滞：三叉神经阻滞、舌咽神经阻滞患者总人数占比"

      #新生儿出生统计
      "baby_num" -> "新生儿总数"
      "baby_rate" -> "新生儿总数占比"
      "boy_num" -> "新生儿男孩数"
      "boy_rate" -> "新生儿男孩数占比"
      "girl_num" -> "新生儿女孩数"
      "girl_rate" -> "新生儿女孩数占比"
      "def_num" -> "新生儿缺陷总数"
      "def_rate" -> "新生儿缺陷总数占比"
      #分娩方式统计
      "ck_num" -> "产科总例数"
      "ck_rate" -> "产科总例数占比"
      "pgc_num" -> "剖宫产例数"
      "pgc_rate" -> "剖宫产例数占比"
      "sc_num" -> "顺产例数"
      "sc_rate" -> "顺产例数占比"
      #出生胎数统计
      "dt_num" -> "单胎总例数"
      "dt_rate" -> "单胎总例数占比"
      "sbt_num" -> "双胞胎总例数"
      "sbt_rate" -> "双胞胎总例数占比"
      "dbt_num" -> "多胞胎总例数"
      "dbt_rate" -> "多胞胎总例数占比"
      "st_num" -> "死胎总例数"
      "st_rate" -> "死胎总例数占比"
      #新生儿出生缺陷统计
      "xhqx_num" -> "消化系统缺陷总例数"
      "sjqx_num" -> "神经系统缺陷总例数"
      "hxqx_num" -> "呼吸系统缺陷总例数"
      "xyqx_num" -> "血液循环系统缺陷总例数"
      "ydqx_num" -> "运动系统缺陷总例数"
      "nfmqx_num" -> "内分泌系统缺陷总例数"
      "mnqx_num" -> "泌尿系统缺陷总例数"
      "szqx_num" -> "生殖系统缺陷总例数"
      #新生儿出生缺陷统计
      "xhqx_rate" -> "消化系统缺陷总例数占比"
      "sjqx_rate" -> "神经系统缺陷总例数占比"
      "hxqx_rate" -> "呼吸系统缺陷总例数占比"
      "xyqx_rate" -> "血液循环系统缺陷总例数占比"
      "ydqx_rate" -> "运动系统缺陷总例数占比"
      "nfmqx_rate" -> "内分泌系统缺陷总例数占比"
      "mnqx_rate" -> "泌尿系统缺陷总例数占比"
      "szqx_rate" -> "生殖系统缺陷总例数占比"
    end
  end
end
