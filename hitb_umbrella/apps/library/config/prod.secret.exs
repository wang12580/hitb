use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :library, LibraryWeb.Endpoint,
  secret_key_base: "Hg/i0dpQnb3ZpKSKCHH2ScHNPWJr21e6DGZatC9YMrcMRPgXdMlNkrqo+Xr4W5Af"

# Configure your database
config :library, Library.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  port: 5432,
  username: "postgres",
  password: "postgres",
  database: "library_dev",
  pool_size: 10
