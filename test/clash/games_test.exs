defmodule Clash.GamesTest do
  use Clash.DataCase

  alias Clash.Games

  describe "games" do
    alias Clash.Games.Game

    import Clash.GamesFixtures

    @invalid_attrs %{date: nil, opponent: nil, my_crowns: nil, opponent_crowns: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{date: ~U[2024-11-12 19:11:00Z], opponent: "some opponent", my_crowns: 42, opponent_crowns: 42}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.date == ~U[2024-11-12 19:11:00Z]
      assert game.opponent == "some opponent"
      assert game.my_crowns == 42
      assert game.opponent_crowns == 42
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{date: ~U[2024-11-13 19:11:00Z], opponent: "some updated opponent", my_crowns: 43, opponent_crowns: 43}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.date == ~U[2024-11-13 19:11:00Z]
      assert game.opponent == "some updated opponent"
      assert game.my_crowns == 43
      assert game.opponent_crowns == 43
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end
