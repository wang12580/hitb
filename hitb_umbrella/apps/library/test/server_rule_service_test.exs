defmodule Library.ServerRuleServiceTest do
  use Hitb.DataCase, async: true
  alias Library.ServerRuleService

  test "test server_rule" do
    assert ServerRuleService.server_rule("mdc", "MDCA") == []
  end

end
