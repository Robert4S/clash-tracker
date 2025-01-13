defmodule ClashWeb.CountLive.Index do
  alias Clash.Games.Opponent
  alias Clash.Repo
  alias Clash.Games.Game
  use ClashWeb, :live_view

  defp games_by_opponent(name) do
    import Ecto.Query

    from o in Opponent,
      where: o.name == ^name,
      join: g in Game,
      on: g.opponent_id == o.id,
      select: g
  end

  defp proper_date(%Game{date: date} = game) do
    date = String.to_charlist(date)
    year = Enum.slice(date, 0, 4)
    month = Enum.slice(date, 4, 2)
    day = Enum.slice(date, 6, 2)
    %Game{game | date: "#{year}-#{month}-#{day}"}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Games won against <%= @opponent %>: <%= @count %>
    </.header>
    <.simple_form for={@form} phx-change="validate" phx-submit="name_searched">
      <.input field={@form["name"]} value="" name="name" />
      <.input
        field={@form["selector_name"]}
        name="selector_name"
        type="select"
        label="Most played against"
        value={nil}
        options={Enum.map(@oftens, &{"#{&1.name}", &1.name})}
      />
      <.button type="submit">Search</.button>
    </.simple_form>
    <%= for {game, won} <- @games do %>
      <div class={[
        if(won, do: "bg-green-100", else: "bg-red-100"),
        "rounded-md my-3 py-2 px-2"
      ]}>
        <.list>
          <:item title="My crowns"><%= game.my_crowns %></:item>
          <:item title={"#{game.opponent.name}'s crowns"}><%= game.opponent_crowns %></:item>
          <:item title="Date"><%= game.date %></:item>
        </.list>
      </div>
    <% end %>
    """
  end

  defp query_opponents(is_bad) do
    import Ecto.Query

    q =
      if is_bad do
        from o in Opponent,
          left_join: g in assoc(o, :games),
          group_by: o.id,
          select: o
      else
        from o in Opponent,
          left_join: g in assoc(o, :games),
          where: g.my_crowns > g.opponent_crowns,
          group_by: o.id,
          select: o
      end

    Repo.all(q)
  end

  @impl true
  def mount(%{"path" => _path}, _session, socket) do
    socket =
      socket
      |> assign(
        opponent: nil,
        games: [],
        count: nil,
        form: %{"name" => "", "selector_name" => ""},
        oftens: query_opponents(false)
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", form, socket) do
    bad =
      form["name"] == "super secret password"

    oftens = query_opponents(bad)

    socket =
      socket
      |> assign(form: form, oftens: oftens)

    {:noreply, socket}
  end

  @impl true
  def handle_event("name_searched", %{"name" => name, "selector_name" => selector_name}, socket) do
    if name |> String.trim() == "" || name == "super secret password" do
      games =
        Repo.all(games_by_opponent(selector_name))
        |> Repo.preload(:opponent)
        |> Enum.map(&proper_date/1)
        |> Enum.map(&{&1, &1.my_crowns > &1.opponent_crowns})

      count = Enum.count(games, fn {_, won} -> won end)

      socket =
        socket
        |> assign(opponent: selector_name, games: games, count: count)

      {:noreply, socket}
    else
      games =
        Repo.all(games_by_opponent(name))
        |> Repo.preload(:opponent)
        |> Enum.map(&proper_date/1)
        |> Enum.map(&{&1, &1.my_crowns > &1.opponent_crowns})

      count = Enum.count(games, fn {_, won} -> won end)

      socket =
        socket
        |> assign(opponent: name, games: games, count: count)

      {:noreply, socket}
    end
  end
end
