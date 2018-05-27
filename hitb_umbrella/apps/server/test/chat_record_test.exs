defmodule Server.ChatRecordServiceTest do
  use Hitb.DataCase, async: true
  alias Server.ChatRecordService

  @chat_record %{room: "room", date: "2018-05-23", record_string: "sss", record_array: ["sss"]}

  test "test list_chat_record" do
    assert ChatRecordService.list_chat_record() == []
  end

  test "test create" do
    {:ok, chat_record} = ChatRecordService.create(@chat_record)
    assert chat_record.id
  end

  test "test get_chat_record!" do
    {:ok, chat_record} = ChatRecordService.create(@chat_record)
    assert ChatRecordService.get_chat_record!(chat_record.id).room == @chat_record.room
  end

  test "test update_chat_record" do
    {:ok, chat_record} = ChatRecordService.create(@chat_record)
    ChatRecordService.update_chat_record(chat_record.id, %{room: "room2"})
    assert ChatRecordService.get_chat_record!(chat_record.id).room == "room2"
  end

  test "test delete_chat_record" do
    {:ok, chat_record} = ChatRecordService.create(@chat_record)
    ChatRecordService.delete_chat_record(chat_record.id)
    assert ChatRecordService.list_chat_record() == []
  end

end
