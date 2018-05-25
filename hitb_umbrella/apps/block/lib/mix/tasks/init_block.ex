defmodule Mix.Tasks.InitBlock do
  use Mix.Task
  @moduledoc """
    initializes the on-disk database and creates necessary tables.
  """
  def run(_args) do
    node = Node.self()
    Node.start(node)

    IO.puts("Initializing Block DB on #{node}...")
    :ok
  end

end
