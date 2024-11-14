defmodule Clash.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clash.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        date: ~U[2024-11-12 19:11:00Z],
        my_crowns: 42,
        opponent: "some opponent",
        opponent_crowns: 42
      })
      |> Clash.Games.create_game()

    game
  end
end
