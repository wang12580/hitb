ExUnit.start()

# Ecto.Adapters.SQL.Sandbox.mode(Block.Repo, :manual)
Mix.Task.run "ecto.create", ~w(-r Block.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Block.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Block.Repo, :manual)
