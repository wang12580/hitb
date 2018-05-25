use Mix.Config
# General application configuration
config :hitb,
  namespace: Hitb,
  ecto_repos: [Hitb.Repo]


import_config "#{Mix.env}.exs"
