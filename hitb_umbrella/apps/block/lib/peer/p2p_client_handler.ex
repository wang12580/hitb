defmodule Block.P2pClientHandler do
  @moduledoc """
  Receives and handles messages over websocket.
  Responsible for keeping the block chain in sync.
  """
  require Logger
  alias Block.PeerRepository
  alias Block.BlockRepository
  alias Phoenix.Channels.GenSocketClient
  @behaviour GenSocketClient

  # can't inherit attributes and use them inside matches, so this is necessary
  @query_all_accounts   Block.P2pMessage.query_all_accounts
  @query_latest_block     Block.P2pMessage.query_latest_block
  @query_all_blocks       Block.P2pMessage.query_all_blocks
  @query_all_transactions   Block.P2pMessage.query_all_transactions
  # @update_block_chain Peers.P2pMessage.update_block_chain
  @add_peer_request   Block.P2pMessage.add_peer_request
  @connection_error   Block.P2pMessage.connection_error
  @connection_success Block.P2pMessage.connection_success

  def start_link(host, port) do
    GenSocketClient.start_link(
          __MODULE__,
          Phoenix.Channels.GenSocketClient.Transport.WebSocketClient,
          "ws://#{host}:#{port}/p2p/websocket"
        )
  end

  def init(url) do
    {:connect, url, [], %{}}
  end

  def join(_transport, _topic, _payload \\ %{}) do

  end

  def handle_connected(transport, state) do
    Logger.info("connected")
    GenSocketClient.join(transport, "p2p")
    {:ok, state}
  end

  def handle_disconnected(reason, state) do
    peer = :ets.tab2list(:peers) |> Enum.reject(fn x -> elem(x, 0) != self() end) |> List.first |> elem(1)
    # PeerRepository.update_peer(peer.host, peer.port, %{connect: false})
    Logger.error("disconnected: #{inspect reason}. 20 minutes later attempting to reconnect...")
    # Process.send_after(self(), :connect, :timer.seconds(20000))
    {:ok, state}
  end

  def handle_joined(topic, _payload, transport, state) do
    Logger.info("joined the topic #{topic}.")
    GenSocketClient.push(transport, "p2p", @query_all_accounts, %{})
    {:ok, state}
  end

  def handle_join_error(topic, payload, _transport, state) do
    Logger.error("join error on the topic #{topic}: #{inspect payload}")
    {:ok, state}
  end

  def handle_channel_closed(topic, payload, _transport, state) do
    Logger.error("disconnected from the topic #{topic}: #{inspect payload}. Attempting to rejoin...")
    Process.send_after(self(), {:join, topic}, :timer.seconds(20000))
    {:ok, state}
  end

  def handle_message(topic, event, payload, _transport, state) do
    Logger.info("message on topic #{topic}: #{event} #{inspect payload}")
    {:ok, state}
  end

  def handle_reply("p2p", _ref, %{"response" => %{"type" => @connection_success}} = payload, _transport, state) do
    Logger.info("server ack ##{inspect payload["response"]}")
    {:ok, state}
  end

  def handle_reply("p2p", _ref, %{"response" => %{"type" => @connection_error}} = payload, _transport, state) do
    Logger.info("connection to server failed...")
    Block.P2pSessionManager.terminate_session(self())
    {:ok, state}
  end

  def handle_reply(topic, _ref, payload, transport, state) do
    type = payload["response"]["type"]
    response = payload["response"]["data"]
    case type do
      "get_all_accounts" ->
        # response
        # |>Enum.map(fn data ->
        #     Map.keys(data) |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, String.to_atom(x), data[x]) end)
        #   end)
        # |>Enum.map(fn x -> Block.AccountRepository.insert_account(x) end)
        GenSocketClient.push(transport, "p2p", @query_latest_block, %{})
      "get_latest_block" ->
        if(Block.BlockService.get_latest_block == nil or Map.get(response, "timestamp") != Map.get(Block.BlockService.get_latest_block, :timestamp))do
          # BlockRepository.insert_block(response)
          GenSocketClient.push(transport, "p2p", @query_all_blocks, %{})
        else
          GenSocketClient.push(transport, "p2p", @query_all_transactions, %{})
        end
      "get_all_blocks" ->
        response
        |>Enum.map(fn data ->
            Map.keys(data) |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, String.to_atom(x), data[x]) end)
          end)
        |>Enum.map(fn x -> Block.BlockRepository.insert_block(x) end)
        GenSocketClient.push(transport, "p2p", @query_all_transactions, %{})
      "query_all_transactions" ->
        response
        |>Enum.map(fn data ->
            Map.keys(data) |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, String.to_atom(x), data[x]) end)
          end)
        |>Enum.map(fn x -> Block.TransactionRepository.insert_transaction(x) end)
    end
    # Logger.warn("reply on topic #{topic}: #{inspect payload}")
    {:ok, state}
  end

  def handle_info(:connect, _transport, state) do
    Logger.info("connecting")
    {:connect, state}
  end

  def handle_info({:join, topic}, transport, state) do
    Logger.info("joining the topic #{topic}")
    case GenSocketClient.join(transport, topic) do
      {:error, reason} ->
        Logger.error("error joining the topic #{topic}: #{inspect reason}. Attempting to rejoin...")
        Process.send_after(self(), {:join, topic}, :timer.seconds(1))
      {:ok, _ref} -> :ok
    end

    {:ok, state}
  end

  def handle_info(@query_latest_block, transport, state) do
    Logger.info("quering for latest blocks")
    GenSocketClient.push(transport, "p2p", @query_latest_block, %{})
    {:ok, state}
  end

  def handle_info(@query_all_blocks, transport, state) do
    Logger.info("querying for all blocks")
    GenSocketClient.push(transport, "p2p", @query_all_blocks, %{})
    {:ok, state}
  end

  def handle_info(@add_peer_request, transport, state) do
    Logger.info("sending request to add me as a peer")
    local_server_host = Application.get_env(:oniichain, HitbWeb.Endpoint)[:url][:host]
    local_server_port = Application.get_env(:oniichain, HitbWeb.Endpoint)[:http][:port]
    GenSocketClient.push(transport, "p2p", @add_peer_request, %{host: local_server_host, port: local_server_port})
    {:ok, state}
  end

  def handle_info(message, _transport, state) do
    Logger.warn("Unhandled message #{inspect message}")
    {:ok, state}
  end

  def handle_call(_message, _arg1, _transport, _callback_state) do
    reply = :reply
    new_state = :new_state
    {:reply, reply, new_state}
  end
end
