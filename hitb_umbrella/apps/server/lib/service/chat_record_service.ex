defmodule Server.ChatRecordService do
  import Ecto.Query
  alias Hitb.Repo
  alias Hitb.Server.ChatRecord

  def list_chat_record() do
    Repo.all(ChatRecord)
  end

  def create(params) do
    changeset = ChatRecord.changeset(%ChatRecord{}, params)
    Repo.insert(changeset)
  end

  def get_chat_record!(id), do: Repo.get!(ChatRecord, id)

  def update_chat_record(id, attrs) do
    Repo.get!(ChatRecord, id)
    |> ChatRecord.changeset(attrs)
    |> Repo.update()
  end

  def delete_chat_record(id) do
    chat_record = Repo.get!(ChatRecord, id)
    Repo.delete(chat_record)
  end

end
