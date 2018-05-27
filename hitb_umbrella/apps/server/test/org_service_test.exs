defmodule Server.OrgServiceTest do
  use Hitb.DataCase, async: true
  alias Server.OrgService

  @org %{"county" => "room", "city" => "2018", "code" => "sss", "name" => "sss", "email" => "sss", "is_show" => false, "is_ban" => false, "level" => "sss", "person_name" => "sss", "province" => "sss", "tel" => "sss", "type" => "sss", "stat_org_name" => 1}

  test "test list_org" do
    assert OrgService.list_org("", 1, 15) == %{org: [], page_list: [], page_num: 1}
  end

  test "test create_org" do
    {:ok, org} = OrgService.create_org(@org)
    assert org.id
  end

  test "test get_org!" do
    {:ok, org} = OrgService.create_org(@org)
    assert OrgService.get_org!(org.id).county == @org["county"]
  end

  test "test update_org" do
    {:ok, org} = OrgService.create_org(@org)
    OrgService.update_org(org.id, %{county: "room2"})
    assert OrgService.get_org!(org.id).county == "room2"
  end

  test "test delete_org" do
    {:ok, org} = OrgService.create_org(@org)
    OrgService.delete_org(org.id)
    assert OrgService.list_org("", 1, 15) == %{org: [], page_list: [], page_num: 1}
  end

end
