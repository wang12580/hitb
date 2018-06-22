defmodule HitbserverWeb.OnlineChannel do
  use Phoenix.Channel
  require Logger
  alias Server.UserService
  alias Edit.CdhService

  def join("online:list", message, socket) do
    if(message["username"])do
      %{"username" => username, "password" => password} = message
      socket = Map.merge(socket, %{username: username})
      cond do
        username in ["hitb", "test@test.com.cn"] ->
          [success, user] = UserService.socket_login(%{password: password, username: username})
          Hitb.ets_insert(:socket_user, username, true)
          Logger.warn("用户--#{username}--加入服务端")
          socket = %{socket | :assigns => user}
          {:ok, socket}
        Hitb.ets_get(:socket_user, username) ->
          {:error, %{reason: "您的账号已在其他地点登录,请先退出后再次尝试登录"}}
        true ->
          [success, user] = UserService.socket_login(%{password: password, username: username})
          if(success)do
            Hitb.ets_insert(:socket_user, username, true)
            Logger.warn("用户--#{username}--加入服务端")
            socket = %{socket | :assigns => user}
            Process.flag(:trap_exit, true)
            :timer.send_interval(5000, :ping)
            {:ok, socket}
          else
            {:error, %{reason: "用户登录失败,账号或密码错误"}}
          end
      end
    else
      {:error, %{reason: "已经登录"}}
    end
  end

  def handle_info(:ping, socket) do
    push socket, "ping", %{username: "SYSTEM", body: "ping", time: Hitb.Time.standard_time(), users: online()  -- [socket.assigns.username] }
    {:noreply, socket}
  end

  def handle_in("cdh帮助", _private, socket) do
    cdh = CdhService.channel_cdh_list()
    broadcast! socket, "cdh帮助", %{cdh: cdh}
    {:noreply, socket}
  end

  def handle_in("用户信息", _private, socket) do
    user = Map.get(socket, :assigns)
    broadcast! socket, "用户信息", %{user: user}
    {:noreply, socket}
  end

  def handle_in("邀请加入" <> _private_room_id, %{"body" => body, "username" => username, "create_room_time" => create_room_time, "invite" => invite, "room_owner" => room_owner}, socket) do
    broadcast! socket, "邀请加入", %{message: "#{username}邀请您进入#{body}房间", time: Hitb.Time.standard_time(), room: body, create_room_time: create_room_time, invite: invite, room_owner: room_owner}
    {:noreply, socket}
  end

  def terminate(_, socket) do
    Hitb.ets_del(:socket_user, socket.assigns.username)
    if(socket.assigns.username != "test@test.com.cn")do
      Logger.warn("用户--#{socket.assigns.username}--已下线")
    end
    :ok
  end

  defp online() do
    Hitb.ets_get(:socket_user, :all_users)
    |>Enum.map(fn x -> %{username: x, online: Hitb.ets_get(:socket_user, x)}  end)
    |>Enum.reject(fn x -> x.online in [nil, false] end)
    |>Enum.map(fn x -> x.username end)
  end

end
