defmodule Stat.Postgres do
  use GenServer
  alias Stat.Repo

  @doc """
  Starts the registry.
  """
  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: Postgres, timeout: 15000000)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, year) do
    GenServer.call(server, {:lookup, year})
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    opts = Repo.config
    {_, hostname} = List.keyfind(opts, :hostname, 0)
    {_, username} = List.keyfind(opts, :username, 0)
    {_, password} = List.keyfind(opts, :password, 0)
    {_, database} = List.keyfind(opts, :database, 0)
    {_, port} = List.keyfind(opts, :port, 0)
    # {:ok, pid} = Postgrex.start_link(hostname: hostname, port: port, username: username, password: password, database: database)
    # Hitbserver.ets_insert(:postgresx, :pid, pid)
    {:ok, Map.new}
  end

  def handle_call({:lookup, year}, _from, names) do
    {:reply, Map.fetch(names, year), names}
  end

  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:noreply, Map.put(names, name, "bucket")}
    end
  end
end
