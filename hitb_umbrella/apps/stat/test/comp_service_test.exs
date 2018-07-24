defmodule Stat.CompServiceTest do
  use ExUnit.Case
  use Hitb.DataCase, async: true
  alias Stat.CompService

  test "test target1" do
    assert CompService.target1("").list == [nil]
  end

  test "test target" do
    assert CompService.target("机构绩效_机构效率") == %{dimension: ["时间", "机构", "病种"], index: 0}
  end

end
