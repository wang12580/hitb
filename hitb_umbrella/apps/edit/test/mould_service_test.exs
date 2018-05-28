defmodule Edit.MouldServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.MouldService

  test "test mould_list" do
    assert MouldService.mould_list("dsasa") == []
  end

  test "test mould_file" do
    assert MouldService.mould_file("sss", "ssda") == []
  end

end
