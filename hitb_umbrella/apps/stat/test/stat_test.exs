defmodule StatTest do
  use ExUnit.Case
  # alias Block.AccountRepository

  test "greets the world" do
    # IO.inspect AccountRepository.get_all_accounts()
    assert Stat.page_en("机构分析_基础分析") == "base"
  end
end
