defmodule Clash.Repo do
  use Ecto.Repo,
    otp_app: :clash,
    adapter: Ecto.Adapters.SQLite3
end
