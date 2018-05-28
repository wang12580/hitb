defmodule HitbserverWeb.ChatRecordController do
  use HitbserverWeb, :controller

  alias Server.ChatRecordService

  def index(conn, _params) do
    chat_record = ChatRecordService.list_chat_record()
    render(conn, "index.json", chat_record: chat_record)
  end

  def create(conn, %{"chat_record" => chat_record_params}) do
    case ChatRecordService.create(chat_record_params) do
      {:ok, chat_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", chat_record_path(conn, :show, chat_record))
        |> render("show.json", chat_record: chat_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HitbserverWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_record = ChatRecordService.get_chat_record!(id)
    render(conn, "show.json", chat_record: chat_record)
  end

  def update(conn, %{"id" => id, "chat_record" => chat_record_params}) do
    case ChatRecordService.update_chat_record(id, chat_record_params) do
      {:ok, chat_record} ->
        render(conn, "show.json", chat_record: chat_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HitbserverWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ChatRecordService.delete_chat_record(id)
    send_resp(conn, :no_content, "")
  end
end
