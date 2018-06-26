defmodule Edit.CdhServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.CdhService

  test "test cdh_list" do
    assert CdhService.cdh_list() == []
  end

  test "test channel_cdh_list" do
    assert CdhService.channel_cdh_list() == %{}
  end

end
