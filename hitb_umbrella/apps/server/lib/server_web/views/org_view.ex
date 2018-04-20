defmodule ServerWeb.OrgView do
  use ServerWeb, :view

  def render("index.json", %{org: org, page_num: page_num, page_list: page_list}) do
    %{data: render_many(org, ServerWeb.OrgView, "org.json"), page_num: page_num, page_list: page_list}
  end

  def render("show.json", %{org: org, success: success}) do
    %{data: render_one(org, ServerWeb.OrgView, "org.json"), success: success}
  end

  def render("org.json", %{org: org}) do
    %{id: org.id,
      city: org.city,
      county: org.county,
      code: org.code,
      name: org.name,
      email: org.email,
      is_show: org.is_show,
      is_ban: org.is_ban,
      level: org.level,
      person_name: org.person_name,
      province: org.province,
      tel: org.tel,
      type: org.type}
  end
end
