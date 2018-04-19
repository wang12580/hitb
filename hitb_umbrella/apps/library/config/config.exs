# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :library,
  namespace: Library,
  ecto_repos: [Library.Repo]

# Configures the endpoint
config :library, LibraryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NFe63FiudSt2y5OiYQG9Mjs3aTqi8xd4Lvla2pCVoDeb2C/sWmZCrtM76t/1+ETw",
  render_errors: [view: LibraryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Library.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
