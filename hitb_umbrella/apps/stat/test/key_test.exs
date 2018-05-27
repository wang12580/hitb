defmodule Stat.KeyTest do
  use Hitb.DataCase, async: true
  alias Stat.Key

  test "test key" do
    assert Key.key("", "", "org", "total", "base") == ["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"]
  end

  test "test tool" do
    assert Key.tool("base") == []
  end

  test "test cnkey" do
    assert Key.cnkey("org") == "机构"
  end

end
