defmodule HitbserverWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("新消息", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "新消息", %{body: body, username: username}
    {:noreply, socket}
  end

  def handle_in("加入房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "加入房间", %{body: body, username: username}
    {:noreply, socket}
  end

  def handle_in("加入房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "加入房间", %{body: body, username: username}
    {:noreply, socket}
  end

  def handle_in("离开房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "离开房间", %{body: body, username: username}
    {:noreply, socket}
  end

  def handle_out("离开房间", %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "离开房间", %{body: body, username: username}
    {:noreply, socket}
  end


end
