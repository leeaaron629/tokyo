defmodule Tokyo.Repo do
  use Ecto.Repo,
    otp_app: :tokyo,
    adapter: Ecto.Adapters.Postgres
end
