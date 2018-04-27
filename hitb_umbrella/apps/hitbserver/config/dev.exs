use Mix.Config

# Configure your database
config :hitbserver, Hitbserver.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hitbserver_dev",
  hostname: "postgres",
  pool_size: 10
