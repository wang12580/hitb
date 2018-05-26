use Mix.Config

config :hitbserver_web, HitbserverWeb.Endpoint,
  #load_from_system_env: false,
  http: [port: 8000],
  url: [host: "127.0.0.1"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  check_origin: false
# import_config "prod.secret.exs"
