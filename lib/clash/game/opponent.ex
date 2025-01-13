defmodule Clash.Games.Opponent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_opponents" do
    field :name, :string
    has_many :games, Clash.Games.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(opponent, attrs) do
    opponent
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
