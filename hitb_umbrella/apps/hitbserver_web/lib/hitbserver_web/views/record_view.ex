defmodule HitbserverWeb.RecordView do
  use HitbserverWeb, :view
  alias HitbserverWeb.RecordView

  def render("index.json", %{record: record, page_list: page_list, page_num: page_num}) do
    %{data: render_many(record, RecordView, "record.json"), page_list: page_list, page_num: page_num}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{id: record.id,
      type: record.type,
      mode: record.mode,
      value: record.value,
      username: record.username}
  end
end
