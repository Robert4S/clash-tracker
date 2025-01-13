defmodule Clash.Repo.Migrations.CreateGameOpponents do
  use Ecto.Migration

  def change do
    create table(:game_opponents) do
      add :name, :string
      add :game_id, references(:games)

      timestamps(type: :utc_datetime)
    end
  end
end
