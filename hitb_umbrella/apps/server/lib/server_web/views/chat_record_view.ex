defmodule ServerWeb.ChatRecordView do
  use ServerWeb, :view

  def render("index.json", %{chat_record: chat_record}) do
    %{data: render_many(chat_record, ServerWeb.ChatRecordView, "chat_record.json")}
  end

  def render("show.json", %{chat_record: chat_record}) do
    %{data: render_one(chat_record, ServerWeb.ChatRecordView, "chat_record.json")}
  end

  def render("chat_record.json", %{chat_record: chat_record}) do
    %{id: chat_record.id,
      room: chat_record.room,
      date: chat_record.date,
      record_string: chat_record.record_string}
  end
end
