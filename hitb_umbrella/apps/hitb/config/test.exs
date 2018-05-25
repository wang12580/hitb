use Mix.Config
# Configure your database
config :hitb, Hitb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "hitb_test",
  hostname: "postgres",
  pool_size: 10
