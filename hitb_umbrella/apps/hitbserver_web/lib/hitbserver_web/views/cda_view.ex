defmodule HitbserverWeb.CdaView do
  use HitbserverWeb, :view
  alias HitbserverWeb.CdaView

  def render("index.json", %{cda: cda}) do
    %{data: render_many(cda, CdaView, "cda.json")}
  end

  def render("show.json", %{cda: cda}) do
    %{data: render_one(cda, CdaView, "cda.json")}
  end

  def render("cda.json", %{cda: cda}) do
    %{id: cda.id,
      username: cda.username,
      name: cda.name,
      content: cda.content}
  end
end
