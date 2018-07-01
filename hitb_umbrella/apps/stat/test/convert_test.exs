defmodule Stat.ConvertTest do
  use ExUnit.Case
  use Hitb.DataCase, async: true
  alias Stat.Convert

  test "test target1" do
    assert Convert.map2list([%{a: "s"}], ["a"]) == [["s"]]
  end

  test "test map" do
    assert Convert.map([%{a: "s"}], ["a"]) == [%{a: "s"}]

  end

end
