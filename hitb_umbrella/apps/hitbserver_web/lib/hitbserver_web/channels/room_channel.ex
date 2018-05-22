defmodule HitbserverWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> private_room_id, message, socket) do
    if(private_room_id in Server.all_user())do
      Process.flag(:trap_exit, true)
      :timer.send_interval(5000, :ping)
      socket = Map.merge(socket, %{username: message["username"]})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:ping, socket) do
    push socket, "ping", %{username: "SYSTEM", body: "ping", time: Hitbserver.Time.standard_time(), users: online()}
    {:noreply, socket}
  end

  def handle_in("新消息", %{"body" => body, "username" => username, "type" => type}, socket) do
    broadcast! socket, "新消息", %{body: body, username: username, type: type, time: Hitbserver.Time.standard_time()}
    {:noreply, socket}
  end

  def handle_in("加入房间", %{"username" => username}, socket) do
    broadcast! socket, "加入房间", %{body: "加入房间", username: username, time: Hitbserver.Time.standard_time(), users: online()}
    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Hitbserver.ets_insert(:socket_user, socket.username, false)
    Logger.warn("用户--#{socket.username}--离开房间,并已下线")
    broadcast! socket, "离开房间", %{body: "离开房间,并已下线", username: socket.username}
    :ok
  end

  def handle_in("离开房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "离开房间", %{body: body, username: username}
    {:noreply, socket}
  end

  defp online() do
    Hitbserver.ets_get(:socket_user, :all_users)
    |>Enum.map(fn x -> %{username: x, online: Hitbserver.ets_get(:socket_user, x)}  end)
    |>Enum.reject(fn x -> x.online in [nil, false] end)
    |>Enum.map(fn x -> x.username end)
  end

end
