defmodule HitbserverWeb.PatientController do
    use HitbserverWeb, :controller
    alias Edit.PatientService
    # alias Hitb.Time
    plug HitbserverWeb.Access
  
    def patient_list(conn, _params) do
      %{"name" => name, "username" => username} = Map.merge(%{"name" => %{}, "username" => ""}, conn.params)
      result = PatientService.patient_list(name, username)
      json conn, %{result: result, success: true}
    end
  
    # def mould_file(conn, _params) do
    #   %{"username" => username, "name" => name} = Map.merge(%{"username" => "", "name" => ""}, conn.params)
    #   result =  MouldService.mould_file(username, name)
    #   json conn, %{result: result, success: true}
    # end
  
  end