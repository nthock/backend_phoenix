# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backend_phoenix,
  ecto_repos: [BackendPhoenix.Repo]

# Configures the endpoint
config :backend_phoenix, BackendPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4UY4iVipbYY9XncnVlZnIEsk8+w1l/MFoDI6LRANlacO0MgiS9apqgknGZATL+cr",
  render_errors: [view: BackendPhoenix.ErrorView, accepts: ~w(json)],
  pubsub: [name: BackendPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
