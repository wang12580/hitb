defmodule HitbserverWeb.OnlineChannel do
  use Phoenix.Channel
  require Logger

  def join("online:list", message, socket) do
    %{"username" => username} = message
    socket = Map.merge(socket, %{username: username})
    IO.inspect Hitb.ets_get(:socket_user, username)
    case Hitb.ets_get(:socket_user, username) do
      true ->
        {:error, %{reason: "已经登录"}}
      _ ->
        Hitb.ets_insert(:socket_user, username, true)
        Logger.warn("用户--#{username}--加入服务端")
        {:ok, socket}
    end
  end

  def handle_in("邀请加入" <> _private_room_id, %{"body" => body, "username" => username, "create_room_time" => create_room_time, "invite" => invite, "room_owner" => room_owner}, socket) do
    broadcast! socket, "邀请加入", %{message: "#{username}邀请您进入#{body}房间", time: Hitb.Time.standard_time(), room: body, create_room_time: create_room_time, invite: invite, room_owner: room_owner}
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Hitb.ets_insert(:socket_user, socket.username, false)
    Logger.warn("用户--#{socket.username}--已下线")
    :ok
  end

end
