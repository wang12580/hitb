defmodule Edit.PatientServiceTest do
  use Hitb.DataCase, async: true
  alias Edit.PatientService

  test "test patient_list" do
    assert PatientService.patient_list(%{"a" =>"a", "b"=>"n"}, "test") == []
  end

  test "test patient_insert" do
    assert PatientService.patient_insert("22222222222", "22222222222", "2222") == %{info: "新建成功", success: true}
  end

end
