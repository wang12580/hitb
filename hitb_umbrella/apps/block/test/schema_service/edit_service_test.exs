defmodule Block.EditServiceTest do
  # use ExUnit.Case
  use Block.DataCase, async: true
  alias Block.EditService
  @cda_file %{username: "sss", filename: "sss", hash: "ssss", previous_hash: "ssss"}
  @cda %{content: "sss", name: "sss", username: "sss", is_show: false, is_change: false}

  test "test get_cda" do
    assert EditService.get_cda()
  end

  test "test get_cdas" do
    assert EditService.get_cdas()
  end

  test "test get_cda_num" do
    assert EditService.get_cda_num()
  end

  test "test get_cda_file" do
    EditService.create_cda_file(@cda_file)
    assert EditService.get_cda_file("sss", "sss")
  end

  test "test create_cda_file" do
    assert EditService.create_cda_file(@cda_file)
  end

  test "test create_cda" do
    assert EditService.create_cda(@cda)
  end


end
