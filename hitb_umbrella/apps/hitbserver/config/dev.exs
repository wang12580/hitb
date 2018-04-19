use Mix.Config

# Configure your database
config :hitbserver, Hitbserver.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hitbserver_dev",
  hostname: "localhost",
  pool_size: 10
