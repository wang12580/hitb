use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :stat, StatWeb.Endpoint,
  secret_key_base: "Hg/i0dpQnb3ZpKSKCHH2ScHNPWJr21e6DGZatC9YMrcMRPgXdMlNkrqo+Xr4W5Af"

# Configure your database
config :stat, Stat.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "rm-2ze8kusu9lj210zc7.pg.rds.aliyuncs.com",
  port: 3433,
  username: "postgres",
  password: "HITBdevgroup1",
  database: "stat_prod",
  pool_size: 20
