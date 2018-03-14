# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hitb_web,
  namespace: HitbWeb

# Configures the endpoint
config :hitb_web, HitbWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT") || 4000],
  secret_key_base: "dqEzstesQkzYjqUZaLSKSyGgNckJhzWexkzoPtJ0P61tmslS2SQMYGvDL6tOrOHM",
  render_errors: [view: HitbWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HitbWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hitb_web, :generators,
  context_app: :hitb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
