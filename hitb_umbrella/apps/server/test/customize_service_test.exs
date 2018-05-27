defmodule Server.CustomizeDepartmentServiceTest do
  use Hitb.DataCase, async: true
  alias Server.CustomizeDepartmentService

  @customize %{"org" => "room", "cherf_department" => "123", "class" => "sss", "department" => "sss", "is_imp" => true, "is_spe" => true, "professor" => "s", "wt_code" => "sss", "wt_name" => "ss", "is_ban" => true}

  test "test list_customize" do
    assert CustomizeDepartmentService.list_customize(1, "",15) == %{customize_department: [], page_list: [], page_num: 1}
  end

  test "test create_customize" do
    {:ok, customize} = CustomizeDepartmentService.create_customize(@customize, %{username: "qwewqwq"})
    assert customize.id
  end

  test "test get_customize!" do
    {:ok, customize} = CustomizeDepartmentService.create_customize(@customize, %{username: "qwewqwq"})
    assert CustomizeDepartmentService.get_customize!(customize.id).org == @customize["org"]
  end

  test "test update_customize" do
    {:ok, customize} = CustomizeDepartmentService.create_customize(@customize, %{username: "qwewqwq"})
    CustomizeDepartmentService.update_customize(customize.id, %{org: "room2"})
    assert CustomizeDepartmentService.get_customize!(customize.id).org == "room2"
  end

  test "test delete_customize" do
    {:ok, customize} = CustomizeDepartmentService.create_customize(@customize, %{username: "qwewqwq"})
    CustomizeDepartmentService.delete_customize(customize.id)
    assert CustomizeDepartmentService.list_customize(1, "",15) == %{customize_department: [], page_list: [], page_num: 1}
  end

end
