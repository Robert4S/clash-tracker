defmodule Clash.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :my_crowns, :integer
      add :opponent_crowns, :integer
      add :date, :string

      timestamps(type: :utc_datetime)
    end
  end
end
