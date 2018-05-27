defmodule Edit.HelpServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.HelpService

  test "test help_list" do
    assert HelpService.help_list() == []
  end

  test "test help_file" do
    assert HelpService.help_file() == []
  end

end
