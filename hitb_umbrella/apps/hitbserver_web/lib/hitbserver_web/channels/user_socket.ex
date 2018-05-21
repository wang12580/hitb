defmodule HitbserverWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  ## Channels
  channel "room:*", HitbserverWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    %{"username" => username} = params
    user =
      if(Hitbserver.ets_get(:socket_user, :online))do
        Hitbserver.ets_get(:socket_user, :online) ++ [username]
      else
        [username]
      end
    Logger.warn("用户--#{username}--加入服务端")
    Hitbserver.ets_insert(:socket_user, :online, user|>:lists.usort)
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     HitbserverWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
