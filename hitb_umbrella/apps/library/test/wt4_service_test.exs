defmodule Library.Wt4ServiceTest do
  use Hitb.DataCase, async: true
  alias Library.Wt4Service

  test "test wt4" do
    assert Wt4Service.wt4(1) == %{drg_num: 0, num: 0, org_num: 0, page_list: [], page_num: 1, time_num: 0, wt4: []}
  end

  test "test stat_wt4" do
    assert Wt4Service.stat_wt4("", "", "", 1) == %{drg_num: 0, num: 0, org_num: 0, page_list: [], time_num: 0, wt4: [], count: 0, page: 1}
  end

end
