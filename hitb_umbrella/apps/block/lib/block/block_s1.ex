defmodule Block.S1 do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(name, value) do
    GenServer.cast(__MODULE__, {:create, name, value})
  end

  def all() do
    GenServer.call(__MODULE__, {:all})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:all}, _from, names) do
    {:reply, names, names}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_cast({:create, name, value}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:noreply, Map.put(names, name, value)}
    end
  end
end
