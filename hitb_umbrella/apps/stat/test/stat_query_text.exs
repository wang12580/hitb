defmodule Stat.StatQueryTest do
  use ExUnit.Case
  use Hitb.DataCase, async: true
  alias Stat.Query

  test "test query_getstat" do
    assert Query.getstat("", "1", "org", "total", "", "", "", "org", "asc", "base", 15, "") == ["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"]
  end

  test "test info" do
    assert Query.info("") == ["org", "time", "weight_count", "zdxg_num", "fee_index", "day_index", "cmi", "fee_avg", "day_avg", "num_sum"]
  end

end
