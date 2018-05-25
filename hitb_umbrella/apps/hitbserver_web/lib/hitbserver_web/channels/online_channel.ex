defmodule HitbserverWeb.OnlineChannel do
  use Phoenix.Channel
  require Logger

  def join("online:list", message, socket) do
    if(message["username"])do
      %{"username" => username, "password" => password} = message
      socket = Map.merge(socket, %{username: username})
      case Hitb.ets_get(:socket_user, username) do
        true ->
          {:error, %{reason: "您的账号已在其他地点登录,请先退出后再次尝试登录"}}
        _ ->
          [success, user] = ServerWeb.MyUser.socket_login(%{password: password, username: username})
          if(success)do
            Hitb.ets_insert(:socket_user, username, true)
            Logger.warn("用户--#{username}--加入服务端")
            socket = Map.put(socket, :user, user)
            {:ok, socket}
          else
            {:error, %{reason: "用户登录失败,账号或密码错误"}}
          end
      end
    else
      {:error, %{reason: "已经登录"}}
    end
  end

  def handle_in("用户信息", _private, socket) do
    user = Map.get(socket, :user)
    broadcast! socket, "用户信息", %{user: user}
    {:noreply, socket}
  end

  def handle_in("邀请加入" <> _private_room_id, %{"body" => body, "username" => username, "create_room_time" => create_room_time, "invite" => invite, "room_owner" => room_owner}, socket) do
    broadcast! socket, "邀请加入", %{message: "#{username}邀请您进入#{body}房间", time: Hitb.Time.standard_time(), room: body, create_room_time: create_room_time, invite: invite, room_owner: room_owner}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    Hitb.ets_del(:socket_user, socket.username)
    Logger.warn("用户--#{socket.username}--已下线")
    :ok
  end

end
