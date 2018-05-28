# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hitbserver_web,
  namespace: HitbserverWeb,
  ecto_repos: [Hitb.Repo]

# Configures the endpoint
config :hitbserver_web, HitbserverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qH3TGcxCBktGfCTG1vg6VCtMnBiZZ3vSms03aHvaPoLdwl+zg4RHNFl6Tlu3dcdA",
  render_errors: [view: HitbserverWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HitbserverWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hitbserver_web, :generators,
  context_app: :hitbserver

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
