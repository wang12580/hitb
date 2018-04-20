use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stat, StatWeb.Endpoint,
  http: [port: 4031],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stat, Stat.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "stat_test",
  port: 5432,
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
