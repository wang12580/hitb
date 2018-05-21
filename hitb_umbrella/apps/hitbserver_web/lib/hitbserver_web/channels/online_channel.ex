defmodule HitbserverWeb.OnlineChannel do
  use Phoenix.Channel
  require Logger

  def join("online:list", _message, socket) do
    {:ok, socket}
  end

  def handle_in("邀请加入" <> _private_room_id, %{"body" => body, "username" => username}, socket) do
    broadcast! socket, "邀请加入", %{message: "#{username}邀请您进入#{body}房间", time: Hitbserver.Time.standard_time(), room: body}
    {:noreply, socket}
  end

end
