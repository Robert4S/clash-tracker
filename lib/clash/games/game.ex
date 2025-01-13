defmodule Clash.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :date, :string
    field :my_crowns, :integer
    field :opponent_crowns, :integer
    belongs_to :opponent, Clash.Games.Opponent

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:opponent, :my_crowns, :opponent_crowns, :date])
    |> validate_required([:opponent, :my_crowns, :opponent_crowns, :date])
  end
end
