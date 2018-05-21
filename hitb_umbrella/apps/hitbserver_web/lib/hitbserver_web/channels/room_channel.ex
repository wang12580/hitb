defmodule HitbserverWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> private_room_id, message, socket) do
    if(private_room_id in Edit.all_cda())do
      # Process.flag(:trap_exit, true)
      # :timer.send_interval(5000, :ping)
      # send(self, {:after_join, message})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # def handle_info({:after_join, msg}, socket) do
  #   broadcast! socket, "user:entered", %{user: msg["user"]}
  #   push socket, "join", %{status: "connected"}
  #   {:noreply, socket}
  # end

  def handle_in("新消息", %{"body" => body, "username" => username, "type" => type}, socket) do
    broadcast! socket, "新消息", %{body: body, username: username, type: type, time: Hitbserver.Time.standard_time()}
    {:noreply, socket}
  end

  def handle_in("加入房间", %{"username" => username}, socket) do
    broadcast! socket, "加入房间", %{body: "加入房间", username: username, time: Hitbserver.Time.standard_time()}
    {:noreply, socket}
  end

  def handle_in("离开房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "离开房间", %{body: body, username: username}
    {:noreply, socket}
  end
end
