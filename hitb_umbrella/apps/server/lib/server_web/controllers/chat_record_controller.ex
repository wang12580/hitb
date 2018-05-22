defmodule ServerWeb.ChatRecordController do
  use ServerWeb, :controller

  alias Server.ChatRecord

  def index(conn, _params) do
    chat_record = Repo.all(ChatRecord)
    render(conn, "index.json", chat_record: chat_record)
  end

  def create(conn, %{"chat_record" => chat_record_params}) do
    changeset = ChatRecord.changeset(%ChatRecord{}, chat_record_params)

    case Repo.insert(changeset) do
      {:ok, chat_record} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", chat_record_path(conn, :show, chat_record))
        |> render("show.json", chat_record: chat_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Server.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chat_record = Repo.get!(ChatRecord, id)
    render(conn, "show.json", chat_record: chat_record)
  end

  def update(conn, %{"id" => id, "chat_record" => chat_record_params}) do
    chat_record = Repo.get!(ChatRecord, id)
    changeset = ChatRecord.changeset(chat_record, chat_record_params)

    case Repo.update(changeset) do
      {:ok, chat_record} ->
        render(conn, "show.json", chat_record: chat_record)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Server.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat_record = Repo.get!(ChatRecord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(chat_record)

    send_resp(conn, :no_content, "")
  end
end
