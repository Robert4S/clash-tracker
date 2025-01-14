defmodule Clash.Poll do
  alias Ecto.Repo
  alias Ecto.Repo
  alias Clash.Games.Game
  alias Clash.Repo
  alias Clash.Games.Opponent
  alias Clash.Games
  use GenServer

  defp get_battles() do
    key = System.get_env("ROYALE_API_KEY")
    req =
      Finch.build(:get, "https://api.clashroyale.com/v1/players/%23C2JPVQCQ2/battlelog", [
        {"Authorization",
         "Bearer #{key}"}
      ])
      |> Finch.request!(Clash.Finch)

    Jason.decode!(req.body)
  end

  defp id_not_in(battle, ids), do: battle["battleTime"] not in ids

  defp poll() do
    battles = get_battles()
    store_battles(battles)
  end

  defp store_battles(battles) do
    stored =
      Games.list_games()
      |> Enum.map(& &1.date)

    # IO.inspect(Enum.at(battles, 0))

    # IO.inspect(Repo.all(Game))
    # for x <- battles, do: IO.inspect(x)

    for x <- battles,
        id_not_in(x, stored) do
      team = x["team"] |> Enum.at(0)
      opponent = x["opponent"] |> Enum.at(0)

      opponent_s =
        case Repo.opponent_by_name(opponent["name"]) do
          [] -> Repo.insert!(%Opponent{name: opponent["name"]})
          [other] -> other
        end

      game = %{
        date: x["battleTime"],
        my_crowns: team["crowns"],
        opponent_crowns: opponent["crowns"]
      }

      opponent = Ecto.build_assoc(opponent_s, :games, game)
      IO.inspect(opponent)
      Repo.insert!(opponent)
    end
  end

  defp schedule_poll() do
    :timer.send_after(60000, :poll)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    poll()
    schedule_poll()
    {:ok, nil}
  end

  @impl true
  def handle_info(:poll, state) do
    poll()
    schedule_poll()
    {:noreply, state}
  end
end
