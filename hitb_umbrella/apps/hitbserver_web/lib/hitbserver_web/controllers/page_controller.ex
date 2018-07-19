defmodule HitbserverWeb.PageController do
  use HitbserverWeb, :controller
  # import Ecto.Query
  alias Server.UserService
  alias Server.UploadService
  # alias Stat.StatCdaService
  plug HitbserverWeb.Access

  def index(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "index.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def test(conn, _params) do
    {:ok, file} = File.open "/home/hitb2/桌面/完成", [:write]
    ["id", "org", "time", "int_time", "code", "version", "property", "option", "dissect", "cc", "mcc", "drg", "name", "drg2", "weight", "info_type", "death_level", "day_avg", "num_num", "num_sum", "death_rate", "death_age_avg", "weight_count", "zdxg_num", "day_index", "fee_index", "cmi", "fee_avg", "wlzl_num", "jrzl_num", "tszl_num", "kfzl_num", "zyzl_num", "ybzl_num", "jszl_num", "wlzl_rate", "jrzl_rate", "tszl_rate", "kfzl_rate", "zyzl_rate", "ybzl_rate", "jszl_rate", "ccu_num", "ricu_num", "sicu_num", "nicu_num", "picu_num", "other_num", "ccu_rate", "ricu_rate", "sicu_rate", "nicu_rate", "picu_rate", "other_rate", "sjkfzc_num", "sjzyzc_num", "cyzzyzc_num", "pjkfbc_num", "bczz_num", "bcgzr_num", "cyzpjzy_num", "bcsy_rate", "ylsy_num", "zl_num", "zl_rate", "jc_num", "jc_rate", "js_num", "js_rate", "yjsy_num", "hsjc_num", "hszl_num", "cszl_num", "fszl_num", "hy_num", "bl_num", "yjsy_rate", "cszl_rate", "fszl_rate", "hy_rate", "bl_rate", "hsjc_expense", "hszl_expense", "cs_expense", "fs_expense", "hy_expense", "bl_expense", "avg_hsjc", "avg_hszl", "avg_cs", "avg_fs", "avg_hy", "avg_bl", "hsjc_rate", "hszl_rate", "csf_rate", "fsf_rate", "hyf_rate", "blf_rate", "jhfz_num", "jhfz_rate", "sx_num", "sx_rate", "sy_num", "sy_rate", "dfx_num", "dfxsw_num", "dfxsw_rate", "dfx_age", "ysj_num", "wsj_num", "zdfx_num", "zdfxsw_num", "zdfxsw_rate", "zdfx_age", "zdysj_num", "zdwsj_num", "zgfx_num", "zgfxsw_num", "zgfxsw_rate", "zgfx_age", "zgysj_num", "zgwsj_num", "gfx_num", "gfxsw_num", "gfxsw_rate", "gfx_age", "gysj_num", "gwsj_num", "yl_expense", "zl_expense", "ybjc_expense", "js_expense", "mz_expense", "ss_expense", "avg_yl", "avg_zl", "avg_ybjc", "avg_js", "avg_mz", "avg_ss", "yl_rate", "zlf_rate", "ybjcf_rate", "jsf_rate", "mzf_rate", "ssf_rate", "jrzl_expense", "tszl_expense", "kfzl_expense", "zyzl_expense", "ybzl_expense", "jszl_expense", "wlzl_expense", "avg_jrzl", "avg_tszl", "avg_kfzl", "avg_zyzl", "avg_ybzl", "avg_jszl", "avg_wlzl", "jrzlf_rate", "tszlf_rate", "kfzlf_rate", "zyzlf_rate", "ybzlf_rate", "jszlf_rate", "wlzlf_rate", "glze_expense", "jhfz_expense", "cw_expense", "gh_expense", "sy_expense", "other_expense", "avg_glze", "avg_jhfz", "avg_cw", "avg_gh", "avg_sy", "avg_other", "glze_rate", "jhfzf_rate", "cwf_rate", "ghf_rate", "syf_rate", "otherf_rate", "zc_expense", "zcy_expense", "avg_zc", "avg_zcy", "zc_rate", "zcy_rate", "hlze_num", "hlzl_num", "hlf_num", "hlzl_avg", "hlf_avg", "hlze_rate", "hlzl_rate", "hlf_rate", "sx_expense", "xy_expense", "kjy_expense", "bdb_expense", "qdb_expense", "nxyz_expense", "xbyz_expense", "avg_sxf", "avg_xyf", "avg_kjy", "avg_bdb", "avg_qdb", "avg_nxyz", "avg_xbyz", "sxf_rate", "xyf_rate", "kjy_rate", "bdb_rate", "qdb_rate", "nxyz_rate", "xbyz_rate", "ypzef", "zlyc_expense", "jryc_expense", "ssyc_expense", "jcyc_expense", "hc_expense", "avg_yp", "avg_zlyc", "avg_jryc", "avg_ssyc", "avg_jcyc", "avg_hc", "yp_rate", "zlyc_rate", "jryc_rate", "ssyc_rate", "jcyc_rate", "hc_rate", "is_inhosp31", "inhosp_rate", "num_num1", "num_rate1", "num_num2", "num_rate2", "num_num3", "num_rate3", "yzly_num", "yzly_rate", "yzzy_num", "yzzy_rate", "yzzsq_num", "yzzsq_rate", "fyzly_num", "fyzly_rate", "rycyfh_num", "rycyfh_rate", "zdblfh_num", "zdblfh_rate", "ryssfh_num", "ryssfh_rate", "num_num", "hlfxsj_num", "syyw_num", "syyl_num", "syyf_num", "syry_num", "sywr_num", "sygl_num", "hlfxsj_rate", "syyw_rate", "syyl_rate", "syyf_rate", "syry_rate", "sywr_rate", "sygl_rate", "sxfxsj_num", "sxyw_num", "sxyl_num", "sxyf_num", "sxwr_num", "sxgl_num", "sxfxsj_rate", "sxyw_rate", "sxyl_rate", "sxyf_rate", "sxwr_rate", "sxgl_rate", "ychz_num", "odyc_num", "wdyc_num", "tdyc_num", "fdyc_num", "ychz_rate", "odyc_rate", "wdyc_rate", "tdyc_rate", "fdyc_rate", "ywdd_num", "ycdd_rate", "zc_num", "ywfxsj_num", "ywfxsj_rate", "ywgl_num", "ywgl_rate", "ywgc_num", "ywgc_rate", "sqday_num", "shday_num", "fjh_num", "fjh_rate", "zdss_num", "sw_num", "sw_rate", "qklk_num", "qklk_rate", "qkgr_num", "qkgr_rate", "shgr_num", "shgr_rate", "shbf_num", "shbf_rate", "yjqk_num", "yjqk_rate", "ejqk_num", "ejqk_rate", "sjqk_num", "sjqk_rate", "yss_num", "yss_rate", "yjqtqk_num", "yjqtqk_rate", "ejqtqk_num", "ejqtqk_rate", "sjqtqk_num", "sjqtqk_rate", "yjyqk_num", "yjyqk_rate", "ejyqk_num", "ejyqk_rate", "sjyqk_num", "sjyqk_rate", "yjbqk_num", "yjbqk_rate", "ejbqk_num", "ejbqk_rate", "sjbqk_num", "sjbqk_rate", "ojss_num", "ojss_rate", "wjss_num", "wjss_rate", "tjss_num", "tjss_rate", "fjss_num", "fjss_rate", "bazlj_num", "bazlj_rate", "bazly_num", "bazly_rate", "bazlb_num", "bazlb_rate", "tl_num", "to_num", "tw_num", "tt_num", "tf_num", "wfpgyf_num", "tl_rate", "to_rate", "tw_rate", "tt_rate", "tf_rate", "wfpgyf_rate", "nl_num", "no_num", "nw_num", "nt_num", "nf_num", "wfpglb_num", "nl_rate", "no_rate", "nw_rate", "nt_rate", "nf_rate", "wfpglb_rate", "ml_num", "ml_rate", "mo_num", "mo_rate", "wfpgyc_num", "wfpgyc_rate", "man_num", "man_rate", "woman_num", "woman_rate", "bd_num", "bd_rate", "wd_num", "wd_rate", "xhxt_num", "sjxt_num", "hxxt_num", "xyxh_num", "ydxt_num", "nfm_num", "mnxt_num", "szxt_num", "xhxt_rate", "sjxt_rate", "hxxt_rate", "xyxh_rate", "ydxt_rate", "nfm_rate", "mnxt_rate", "szxt_rate", "zlfq_num", "gfh_num", "zfh_num", "dfh_num", "wfh_num", "wqd_num", "zlfq_rate", "gfh_rate", "zfh_rate", "dfh_rate", "wfh_rate", "wqd_rate", "txb_num", "txb_rate", "bxb_num", "bxb_rate", "ftfbxb_num", "ftfbxb_rate", "nk_num", "nk_rate", "lczg_num", "xxct_num", "sszd_num", "shmy_num", "xbx_num", "bljf_num", "blyf_num", "sjybl_num", "zgzdyj_num", "lczg_rate", "xxct_rate", "sszd_rate", "shmy_rate", "xbx_rate", "bljf_rate", "blyf_rate", "sjybl_rate", "zgzdyj_rate", "rhya_num", "rhya_rate", "rhyb_num", "rhyb_rate", "rhyo_num", "rhyo_rate", "rhyab_num", "rhyab_rate", "rhbxa_num", "rhbxa_rate", "rhbxb_num", "rhbxb_rate", "rhbxo_num", "rhbxo_rate", "rhbxab_num", "rhbxab_rate", "rhyxa_num", "rhyxa_rate", "rhyxb_num", "rhyxb_rate", "rhyxo_num", "rhyxo_rate", "rhyxab_num", "rhyxab_rate", "rhyxa_cc", "rhyxb_cc", "rhyxab_cc", "rhyxo_cc", "rhyxacc_rate", "rhyxbcc_rate", "rhyxabcc_rate", "rhyx0cc_rate", "rhyacc_rate", "rhybcc_rate", "rhyabcc_rate", "rhy0cc_rate", "rhya_cc", "rhyb_cc", "rhyab_cc", "rhyo_cc", "cfx_num", "hxb_num", "xsb_num", "xj_num", "qx_num", "qtx_num", "cfx_avg", "hxb_avg", "xsb_avg", "xj_avg", "qx_avg", "qtx_avg", "sum_rate", "cfx_rate", "hxb_rate", "xsb_rate", "xj_rate", "qx_rate", "qtx_rate", "bszg_num", "bszgzf_num", "bszgyl_num", "bszgyj_num", "bszgypj_num", "bszghl_num", "bszggl_num", "bszg_avg", "bszgzf_avg", "bszgyl_avg", "bszgyj_avg", "bszgypj_avg", "bszghl_avg", "bszggl_avg", "bszg_rate", "bszgzf_rate", "bszgyl_rate", "bszgyj_rate", "bszgypj_rate", "bszghl_rate", "bszggl_rate", "wbzg_num", "wbzgzf_num", "wbzgyl_num", "wbzgyj_num", "wbzgypj_num", "wbzghl_num", "wbzggl_num", "wbzg_avg", "wbzgzf_avg", "wbzgyl_avg", "wbzgyj_avg", "wbzgypj_avg", "wbzghl_avg", "wbzggl_avg", "wbzg_rate", "wbzgzf_rate", "wbzgyl_rate", "wbzgyj_rate", "wbzgypj_rate", "wbzghl_rate", "wbzggl_rate", "bsjm_num", "bsjmzf_num", "bsjmyl_num", "bsjmyj_num", "bsjmypj_num", "bsjmhl_num", "bsjmgl_num", "bsjm_avg", "bsjmzf_avg", "bsjmyl_avg", "bsjmyj_avg", "bsjmypj_avg", "bsjmhl_avg", "bsjmgl_avg", "bsjm_rate", "bsjmzf_rate", "bsjmyl_rate", "bsjmyj_rate", "bsjmypj_rate", "bsjmhl_rate", "bsjmgl_rate", "wbjm_num", "wbjmzf_num", "wbjmyl_num", "wbjmyj_num", "wbjmypj_num", "wbjmhl_num", "wbjmgl_num", "wbjm_avg", "wbjmzf_avg", "wbjmyl_avg", "wbjmyj_avg", "wbjmypj_avg", "wbjmhl_avg", "wbjmgl_avg", "wbjm_rate", "wbjmzf_rate", "wbjmyl_rate", "wbjmyj_rate", "wbjmypj_rate", "wbjmhl_rate", "wbjmgl_rate", "bsxnh_num", "bsxnhzf_num", "bsxnhyl_num", "bsxnhyj_num", "bsxnhypj_num", "bsxnhhl_num", "bsxnhgl_num", "bsxnh_avg", "bsxnhzf_avg", "bsxnhyl_avg", "bsxnhyj_avg", "bsxnhypj_avg", "bsxnhhl_avg", "bsxnhgl_avg", "bsxnh_rate", "bsxnhzf_rate", "bsxnhyl_rate", "bsxnhyj_rate", "bsxnhypj_rate", "bsxnhhl_rate", "bsxnhgl_rate", "wbxnh_num", "wbxnhzf_num", "wbxnhyl_num", "wbxnhyj_num", "wbxnhypj_num", "wbxnhhl_num", "wbxnhgl_num", "wbxnh_avg", "wbxnhzf_avg", "wbxnhyl_avg", "wbxnhyj_avg", "wbxnhypj_avg", "wbxnhhl_avg", "wbxnhgl_avg", "wbxnh_rate", "wbxnhzf_rate", "wbxnhyl_rate", "wbxnhyj_rate", "wbxnhypj_rate", "wbxnhhl_rate", "wbxnhgl_rate", "pkjz_num", "pkjzzf_num", "pkjzyl_num", "pkjzyj_num", "pkjzypj_num", "pkjzhl_num", "pkjzgl_num", "pkjz_avg", "pkjzzf_avg", "pkjzyl_avg", "pkjzyj_avg", "pkjzypj_avg", "pkjzhl_avg", "pkjzgl_avg", "pkjz_rate", "pkjzzf_rate", "pkjzyl_rate", "pkjzyj_rate", "pkjzypj_rate", "pkjzhl_rate", "pkjzgl_rate", "sybx_num", "sybxzf_num", "sybxyl_num", "sybxyj_num", "sybxypj_num", "sybxhl_num", "sybxgl_num", "sybx_avg", "sybxzf_avg", "sybxyl_avg", "sybxyj_avg", "sybxypj_avg", "sybxhl_avg", "sybxgl_avg", "sybx_rate", "sybxzf_rate", "sybxyl_rate", "sybxyj_rate", "sybxypj_rate", "sybxhl_rate", "sybxgl_rate", "qgf_num", "qgfzf_num", "qgfyl_num", "qgfyj_num", "qgfypj_num", "qgfhl_num", "qgfgl_num", "qgf_avg", "qgfzf_avg", "qgfyl_avg", "qgfyj_avg", "qgfypj_avg", "qgfhl_avg", "qgfgl_avg", "qgf_rate", "qgfzf_rate", "qgfyl_rate", "qgfyj_rate", "qgfypj_rate", "qgfhl_rate", "qgfgl_rate", "qzf_num", "qzfyl_num", "qzfyj_num", "qzfypj_num", "qzfhl_num", "qzfgl_num", "qzf_avg", "qzfyl_avg", "qzfyj_avg", "qzfypj_avg", "qzfhl_avg", "qzfgl_avg", "qzf_rate", "qzfyl_rate", "qzfyj_rate", "qzfypj_rate", "qzfhl_rate", "qzfgl_rate", "qtbx_num", "qtbxzf_num", "qtbxyl_num", "qtbxyj_num", "qtbxypj_num", "qtbxhl_num", "qtbxgl_num", "qtbx_avg", "qtbxzf_avg", "qtbxyl_avg", "qtbxyj_avg", "qtbxypj_avg", "qtbxhl_avg", "qtbxgl_avg", "qtbx_rate", "qtbxzf_rate", "qtbxyl_rate", "qtbxyj_rate", "qtbxypj_rate", "qtbxhl_rate", "qtbxgl_rate", "qthz_num", "qthzzf_num", "qthzyl_num", "qthzyj_num", "qthzypj_num", "qthzhl_num", "qthzgl_num", "qthz_avg", "qthzzf_avg", "qthzyl_avg", "qthzyj_avg", "qthzypj_avg", "qthzhl_avg", "qthzgl_avg", "qthz_rate", "qthzzf_rate", "qthzyl_rate", "qthzyj_rate", "qthzypj_rate", "qthzhl_rate", "qthzgl_rate", "ssywss_num", "ssywqg_num", "ssywzc_num", "ssywck_num", "ssywcx_num", "ssylyw_num", "sswjsb_num", "ssczbd_num", "ssywss_rate", "ssywqg_rate", "ssywzc_rate", "ssywck_rate", "ssywcx_rate", "ssylyw_rate", "sswjsb_rate", "ssczbd_rate", "zlywzl_num", "zlywqg_num", "zlywzc_num", "zlywck_num", "zlywcx_num", "zlylyw_num", "zlwjsb_num", "zlczbd_num", "zlywzl_rate", "zlywqg_rate", "zlywzc_rate", "zlywck_rate", "zlywcx_rate", "zlylyw_rate", "zlwjsb_rate", "zlczbd_rate", "szh_num", "czh_num", "ssh_num", "stx_num", "rgjt_num", "ylqj_num", "szh_rate", "czh_rate", "ssh_rate", "stx_rate", "rgjt_rate", "ylqj_rate", "ssls_num", "mzzy_num", "jzzy_num", "ybzf_num", "xnh_num", "qzfbl_num", "qgfbl_num", "ssls_rate", "mzzy_rate", "jzzy_rate", "ybzf_rate", "xnh_rate", "qzfbl_rate", "qgfbl_rate", "hos_num", "pc_num", "wrmdc_num", "wrz_num", "qy_num", "drg_rate", "blood_num", "ablood_num", "bblood_num", "abblood_num", "oblood_num", "wcblood_num", "blood_rate", "ablood_rate", "bblood_rate", "abblood_rate", "oblood_rate", "wcblood_rate", "mz_num", "wmz_num", "qsmz_num", "xrmz_num", "jmmz_num", "jcmz_num", "qymz_num", "zgnmz_num", "mz_rate", "wmz_rate", "qsmz_rate", "xrmz_rate", "jmmz_rate", "jcmz_rate", "qymz_rate", "zgnmz_rate", "ymwfh_num", "fhmz_num", "btywfh_num", "btfffh_num", "tsfffh_num", "jxfh_num", "qtmz_num", "ymwfh_rate", "fhmz_rate", "btywfh_rate", "btfffh_rate", "tsfffh_rate", "jxfh_rate", "qtmz_rate", "zwmx_num", "zwmx_rate", "ymw_num", "ymw_rate", "sj_num", "sj_rate", "bc_num", "yz_num", "qg_num", "zp_num", "per_num", "jg_num", "xy_num", "n_num", "bc_rate", "yz_rate", "qg_rate", "zp_rate", "per_rate", "jg_rate", "xy_rate", "n_rate", "baby_num", "baby_rate", "boy_num", "boy_rate", "girl_num", "girl_rate", "def_num", "def_rate", "ck_num", "ck_rate", "pgc_num", "pgc_rate", "sc_num", "sc_rate", "dt_num", "dt_rate", "sbt_num", "sbt_rate", "dbt_num", "dbt_rate", "st_num", "st_rate", "xhqx_num", "sjqx_num", "hxqx_num", "xyqx_num", "ydqx_num", "nfmqx_num", "mnqx_num", "szqx_num", "xhqx_rate", "sjqx_rate", "hxqx_rate", "xyqx_rate", "ydqx_rate", "nfmqx_rate", "mnqx_rate", "szqx_rate"]
    |>Enum.each(fn x ->
        IO.inspect Stat.Key.cnkey(x)
        IO.binwrite file, "\"#{Stat.Key.cnkey(x)}\" -> \"#{x}\"\n"
      end)

    json conn, %{}
  end

  def chat(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "chat_test.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end

  def login_html(conn, _params)do
    user = get_session(conn, :user)
    user = UserService.user_info(user)
    render conn, "login.html", user: user
  end

  def login(conn, %{"user" => user}) do
    %{"username" => username, "password" => password} = user
    [user, login] = UserService.login(%{username: username, password: password}, %{})
    conn =
      case login do
        false ->
          put_session(conn, :user, %{login: false, username: "", type: 2, key: []})
        true ->
          put_session(conn, :user, %{id: user.id, login: login, username: username, type: user.type, key: user.key})
      end
    json conn, %{login: true, username: username}
  end

  def logout(conn, _params) do
    user = UserService.logout()
    conn = put_session(conn, :user, user)
    redirect conn, to: "/hospitals/login"
  end

  def wt4_upload(conn, _params) do
    wt4s = UploadService.wt4_upload(conn)
    json conn, wt4s
  end

  def wt4_insert(conn, _params) do
    wt4s = UploadService.wt4_insert()
    json conn, wt4s
  end

  def share(conn, _params) do
    user = get_session(conn, :user)
    login = UserService.is_login(user)
    if(login)do
      %{"page" => page} = Map.merge(%{"page" => "1"}, conn.params)
      render conn, "share.html", user: user, page_num: page
    else
      redirect conn, to: "/hospitals/login"
    end
  end
  def connect(conn, _params) do
    json conn, %{success: true}
  end
end
