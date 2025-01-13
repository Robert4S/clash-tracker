defmodule Clash.Repo do
  alias Clash.Games.Opponent

  use Ecto.Repo,
    otp_app: :clash,
    adapter: Ecto.Adapters.SQLite3

  def opponent_by_name(name) do
    import Ecto.Query

    q =
      from o in Opponent,
        where: o.name == ^name,
        select: o

    all(q)
  end
end
