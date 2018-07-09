defmodule HitbserverWeb.StatCdaController do
  use HitbserverWeb, :controller
  alias Stat.StatCdaService
  # alias Hitb.Time
  plug HitbserverWeb.Access

  def cda_consult(conn, _oarams) do
    %{"item" => item} = Map.merge(%{"item" => ""}, conn.params)
    result =
      case item do
        "" -> []
        _->
          StatCdaService.get_stat_cda(item)
      end
    json conn, %{cda: result}
  end
end
