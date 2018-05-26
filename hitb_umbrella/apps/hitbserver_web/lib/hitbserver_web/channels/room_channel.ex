defmodule HitbserverWeb.RoomChannel do
  use Phoenix.Channel
  alias Hitb.Repo
  alias Hitb.Server.ChatRecord
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> private_room_id, message, socket) do
    if(private_room_id in Server.UserService.all_user())do
      Process.flag(:trap_exit, true)
      :timer.send_interval(5000, :ping)
      socket = Map.merge(socket, %{username: message["username"]})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:ping, socket) do
    push socket, "ping", %{username: "SYSTEM", body: "ping", time: Hitb.Time.standard_time(), users: online() }
    {:noreply, socket}
  end

  def handle_in("新消息", %{"body" => body, "username" => username, "type" => type, "create_room_time" => create_room_time}, socket) do
    record = Repo.get_by(ChatRecord, room: username, date: create_room_time)
    if(type == "doc")do
      broadcast! socket, "共享文档", %{body: body, username: username, type: type, time: Hitb.Time.standard_time(), create_room_time: create_room_time}
    else
      if(record != nil)do
        bodystring = record.record_string <>"@%@"<>body
        bodyarray = record.record_array ++ [body]
        record
        |>ChatRecord.changeset(%{record_string: bodystring, record_array: bodyarray})
        |>Repo.update
      else
        record_body = %{"room" => username, "date" => create_room_time, "record_string" => body, "record_array" => [body]}
        %ChatRecord{}
        |> ChatRecord.changeset(record_body)
        |> Repo.insert()
      end
      broadcast! socket, "新消息", %{body: body, username: username, type: type, time: Hitb.Time.standard_time(), create_room_time: create_room_time}
    end
    {:noreply, socket}
  end

  def handle_in("加入房间", %{"username" => username, "create_room_time" => _create_room_time}, socket) do
    time = Hitb.Time.standard_time()
    broadcast! socket, "加入房间", %{body: "加入房间", username: username, time: time, users: online(), create_room_time: time}
    {:noreply, socket}
  end

  def handle_in("离开房间", %{"body" => body, "username" => username}, socket) do
    Hitb.ets_del(:socket_user, socket.username)
    broadcast! socket, "离开房间", %{body: body, username: username}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    Hitb.ets_del(:socket_user, socket.username)
    Logger.warn("用户--#{socket.username}--离开房间")
    broadcast! socket, "离开房间", %{body: "离开房间", username: socket.username}
    :ok
  end

  defp online() do
    Hitb.ets_get(:socket_user, :all_users)
    |>Enum.map(fn x -> %{username: x, online: Hitb.ets_get(:socket_user, x)}  end)
    |>Enum.reject(fn x -> x.online in [nil, false] end)
    |>Enum.map(fn x -> x.username end)
  end

end
