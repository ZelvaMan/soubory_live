# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :soubory_live, SouboryLiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2OD08JuEwfF4jdSw1bz0eyQts8iMkFHXjIkU112/Ia0CC8AUvcm9DyP8OKs2W/+u",
  render_errors: [view: SouboryLiveWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SouboryLive.PubSub,
  live_view: [signing_salt: "kI0U1Mqb"],
  path: "C:/TEST/"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :soubory_live, SouboryLive.Scheduler,
  jobs: [
    # Every minute
    {"*/5 * * * *", {SouboryLive.FileHelper, :delete_zips, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
