defmodule HitbserverWeb.UserView do
  use HitbserverWeb, :view
  alias HitbserverWeb.UserView

  def render("index.json", %{user: user, page_list: page_list, page_num: page_num}) do
    %{data: render_many(user, UserView, "user.json"), page_list: page_list, page_num: page_num}
  end

  def render("show.json", %{user: user, success: success}) do
    %{data: render_one(user, UserView, "user.json"), success: success}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      # hashpw: user.hashpw,
      org: user.org,
      age: user.age,
      email: user.email,
      tel: user.tel,
      is_show: user.is_show,
      name: user.name,
      type: user.type,
      block_address: user.block_address}
  end
end
