use Mix.Config

config :hitbserver, ecto_repos: [Hitbserver.Repo]

import_config "#{Mix.env}.exs"
