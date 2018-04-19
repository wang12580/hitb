defmodule HitbWeb.Access do
  import Plug.Conn
  use HitbWeb, :controller

  def init() do
    IO.inspect "this is a response plug!"
  end

  def call(conn, _opts) do
    %{conn | :resp_headers => conn.resp_headers ++ [{"Access-Control-Allow-Origin", "*"}]}
  end

end
