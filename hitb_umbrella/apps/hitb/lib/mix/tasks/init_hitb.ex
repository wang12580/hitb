defmodule Mix.Tasks.InitHitb do
  use Mix.Task
  @moduledoc """
    initializes the on-disk database and creates necessary tables.
  """
  def run(_args) do
    IO.puts("Initializing Hitb DB on ...")
    :ok
  end

end
