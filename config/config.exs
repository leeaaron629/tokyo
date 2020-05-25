import Config


config :tokyo, ecto_repos: [Tokyo.Repo]

config :tokyo, Tokyo.Repo,
  migration_default_prefix: "tokyo",
  migration_primary_key: [name: :alskdfjl, type: :binary_id],
  database: "tokyo",
  username: System.fetch_env!("PSQL_USERNAME"),
  password: System.fetch_env!("PSQL_PASSWORD"),
  hostname: "localhost"
  # url: "postgres://postgres:postgres@localhost/ecto_simple"

config :tokyo, initial_repo_state: %{}

