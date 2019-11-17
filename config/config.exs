import Config


config :tokyo, ecto_repos: [Tokyo.Repo]

config :tokyo, Tokyo.Repo,
  database: "tokyo_repo",
  username: "postgres",
  password: "abc123",
  hostname: "localhost"

config :tokyo, initial_repo_state: %{}

