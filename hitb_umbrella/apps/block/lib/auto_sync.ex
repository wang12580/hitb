defmodule Block.AutoSyncService do
  alias Phoenix.Channels.GenSocketClient
  @behaviour GenSocketClient

  def sync()do
    transport = :ets.lookup(:client, :transport)
    if(transport != [])do
      transport |> hd |> elem(1)
      |>Enum.each(fn x ->
          GenSocketClient.push(x, "p2p", "auto_sync", %{})
        end)
    end
  end

end
