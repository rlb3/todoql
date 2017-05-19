# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo,
  ecto_repos: [Todo.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :todo, Todo.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4zeiLuUoixnLcxnhaFo8TYrOka0Hx7C6haF+XTjkUl3AQjK4AZGrB22qJgoKO4nV",
  render_errors: [view: Todo.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Todo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
verify_module: Guardian.JWT,  # optional
issuer: "Todo",
  ttl: { 30, :days },
  verify_issuer: true, # optional
secret_key: "arkriG6NcC4a++Ekdftjgsj2vn1hDNBr/CrfZXt/eYGCC1guLqTvrclaOJIbSK2c",
  serializer: Todo.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
