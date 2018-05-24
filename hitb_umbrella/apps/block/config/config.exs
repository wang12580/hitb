use Mix.Config

# General application configuration
config :block,
  namespace: Block,
  ecto_repos: [Block.Repo]



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
