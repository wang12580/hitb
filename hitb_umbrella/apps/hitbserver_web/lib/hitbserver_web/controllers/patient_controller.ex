defmodule HitbserverWeb.PatientController do
    use HitbserverWeb, :controller
    alias Edit.PatientService
    # alias Hitb.Time
    plug HitbserverWeb.Access

    def patient_list(conn, _params) do
      %{"info" => info, "username" => _username} = Map.merge(%{"info" => %{}, "username" => ""}, conn.params)
      result = PatientService.patient_list(info)
      json conn, %{result: result, success: true}
    end

    # def mould_file(conn, _params) do
    #   %{"username" => username, "name" => name} = Map.merge(%{"username" => "", "name" => ""}, conn.params)
    #   result =  MouldService.mould_file(username, name)
    #   json conn, %{result: result, success: true}
    # end

  end
