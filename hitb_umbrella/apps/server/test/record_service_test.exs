defmodule Server.RecordServiceTest do
  use Hitb.DataCase, async: true
  alias Server.RecordService

  @record %{mode: "room", type: "2018", username: "sss", old_value: "sss", value: "sss"}

  test "test list_record" do
    assert RecordService.list_record(1, 15) == [0, []]
  end

  test "test create_record" do
    {:ok, record} = RecordService.create_record(@record)
    assert record.id
  end

  test "test get_record!" do
    {:ok, record} = RecordService.create_record(@record)
    assert RecordService.get_record!(record.id).mode == @record.mode
  end

  test "test delete_record" do
    {:ok, record} = RecordService.create_record(@record)
    RecordService.delete_record(record.id)
    assert RecordService.list_record(1, 15) == [0, []]
  end

end
