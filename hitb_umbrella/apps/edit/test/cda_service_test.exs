defmodule Edit.CdaServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.CdaService

  test "test cda_user" do
    assert CdaService.cda_user() == [[], "读取成功"]
  end

  test "test cda_files" do
    assert CdaService.cda_files("test", "server") == [[], "读取成功"]
  end

  test "test cda_file" do
    assert CdaService.cda_file("test.cda", "test") == [[],["文件读取失败,无此文件"]]
  end

  test "test update" do
    assert CdaService.update("sdasd dsadsa", "test.cda", "test", "doctype", "sadas").success == true
  end

end
