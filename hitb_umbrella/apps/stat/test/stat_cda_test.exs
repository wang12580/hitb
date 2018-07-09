defmodule Stat.StatCdaServiceTest do
  use ExUnit.Case
  use Hitb.DataCase, async: true
  alias Stat.StatCdaService

  test "test get_stat_cda" do
    assert StatCdaService.get_stat_cda("sss saas")
  end

  test "test comp" do
    assert StatCdaService.comp() == :ok
  end

  test "test init_comp" do
    assert StatCdaService.init_comp() == :ok
  end

end
