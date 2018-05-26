defmodule EditWeb.MyMouldView do
  use EditWeb, :view
  alias EditWeb.MyMouldView

  def render("index.json", %{my_mould: my_mould}) do
    %{data: render_many(my_mould, MouldView, "my_mould.json")}
  end

  def render("show.json", %{my_mould: my_mould}) do
    %{data: render_one(my_mould, MyMouldView, "my_mould.json")}
  end

  def render("my_mould.json", %{my_mould: my_mould}) do
    %{id: my_mould.id,
      username: my_mould.username,
      name: my_mould.name,
      content: my_mould.content}
  end
end
