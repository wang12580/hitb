defmodule HitbserverWeb.Wt4View do
  use HitbserverWeb, :view

  def render("index.json", %{wt4: wt4, page_num: page_num, page_list: page_list, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num}) do
    %{data: render_many(wt4, HitbserverWeb.Wt4View, "wt4.json"), page_num: page_num, page_list: page_list, num: num, org_num: org_num, time_num: time_num, drg_num: drg_num}
  end

  def render("show.json", %{wt4: wt4}) do
    %{data: render_one(wt4, HitbserverWeb.Wt4View, "wt4.json")}
  end

  def render("wt4.json", %{wt4: wt4}) do
    %{id: wt4.id,
      acctual_days: wt4.acctual_days,
      age: wt4.age,
      b_wt4_v1_id: wt4.b_wt4_v1_id,
      case_id: wt4.case_id,
      date_inhospital: wt4.date_inhospital,
      # department_code2: wt4.department_code2,
      director_doctor: wt4.director_doctor,
      disease_code: wt4.disease_code,
      # disease_name: wt4.disease_name,
      expense_gl: wt4.expense_gl,
      expense_hl: wt4.expense_hl,
      expense_yj: wt4.expense_yj,
      expense_yl: wt4.expense_yl,
      expense_yp: wt4.expense_yp,
      expense_yp_hc: wt4.expense_yp_hc,
      gender: wt4.gender,
      # org_catalog_code: wt4.org_catalog_code,
      # org_class_code: wt4.org_class_code,
      # org_code: wt4.org_code,
      # org_id: wt4.org_id,
      # out_date: wt4.out_date,
      # pay_type: wt4.pay_type,
      # season_time: wt4.season_time,
      sf0100: wt4.sf0100,
      sf0102: wt4.sf0102,
      sf0104: wt4.sf0104,
      sf0108: wt4.sf0108,
      total_expense: wt4.total_expense,
      year_time: wt4.year_time,
      month_time: wt4.month_time,
      diags_code: wt4.diags_code,
      opers_code: wt4.opers_code,
      # org_level: wt4.org_level,
      # org_name: wt4.org_name,
      # org_zone: wt4.org_zone,
      # departiment_code2: wt4.departiment_code2,
      # drg_bj: wt4.drg_bj,
      # error_bj: wt4.error_bj,
      # error_log_bj: wt4.error_log_bj,
      # log_bj: wt4.log_bj,
      # mcc_bj: wt4.mcc_bj,
      # mdc_bj: wt4.mdc_bj,
      # mdcs_main_bj: wt4.mdcs_main_bj,
      # oper_code_bj: wt4.oper_code_bj,
      # opers_adrg_bj: wt4.opers_adrg_bj,
      # drg_cc: wt4.drg_cc,
      # error_cc: wt4.error_cc,
      # error_log_cc: wt4.error_log_cc,
      # log_cc: wt4.log_cc,
      # mcc_cc: wt4.mcc_cc,
      # mdc_cc: wt4.mdc_cc,
      # mdcs_main_cc: wt4.mdcs_main_cc,
      # oper_code_cc: wt4.oper_code_cc,
      # opers_adrg_cc: wt4.opers_adrg_cc,
      # drg_test: wt4.drg_test,
      # error_test: wt4.error_test,
      # error_log_test: wt4.error_log_test,
      # log_test: wt4.log_test,
      # mcc_test: wt4.mcc_test,
      # mdc_test: wt4.mdc_test,
      # mdcs_main_test: wt4.mdcs_main_test,
      # oper_code_test: wt4.oper_code_test,
      # opers_adrg_test: wt4.opers_adrg_test
      }
  end
end
