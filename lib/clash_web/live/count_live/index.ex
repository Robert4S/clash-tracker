defmodule ClashWeb.CountLive.Index do
  alias Clash.Repo
  alias Clash.Games.Game
  use ClashWeb, :live_view

  defp games_by_opponent(name) do
    import Ecto.Query

    from b in Game,
      where: b.opponent == ^name,
      select: b
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
      <.button type="submit">Search</.button>
    </.simple_form>
    <%= for {game, won} <- @games do %>
      <div class={[
        if(won, do: "bg-green-100", else: "bg-red-100"),
        "rounded-md my-3 py-2 px-2"
      ]}>
        <.list>
          <:item title="My crowns"><%= game.my_crowns %></:item>
          <:item title={"#{game.opponent}'s crowns"}><%= game.opponent_crowns %></:item>
          <:item title="Date"><%= game.date %></:item>
        </.list>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(opponent: nil, games: [], count: nil, form: %{"name" => ""})

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", form, socket) do
    socket =
      socket
      |> assign(form: form)

    {:noreply, socket}
  end

  @impl true
  def handle_event("name_searched", %{"name" => name}, socket) do
    games =
      Repo.all(games_by_opponent(name))
      |> Enum.map(&proper_date/1)
      |> Enum.map(&{&1, &1.my_crowns > &1.opponent_crowns})

    count = Enum.count(games, fn {_, won} -> won end)

    socket =
      socket
      |> assign(opponent: name, games: games, count: count)

    {:noreply, socket}
  end
end
