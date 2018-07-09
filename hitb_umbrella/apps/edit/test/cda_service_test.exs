defmodule Edit.CdaServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.CdaService

  test "test cda_user" do
    assert CdaService.cda_user("server") == [[], "读取成功"]
  end

  test "test cda_files" do
    assert CdaService.cda_files("test", "server") == [[], "读取成功"]
  end

  test "test cda_file" do
    assert CdaService.cda_file("test.cda", "test") == [%{content: "", header: ""},["文件读取失败,无此文件"]]
  end

  test "test update" do
    assert CdaService.update("", "sdasd dsadsa,姓名 a,年龄 20,出生地 来了,职业 急急急,婚姻状况 来了,民族 啊啊,性别 啊", "test.cda", "test", "doctype", "sadas", %{}, "新建").success == true
  end

end
