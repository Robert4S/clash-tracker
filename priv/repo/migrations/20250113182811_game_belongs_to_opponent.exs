defmodule Clash.Repo.Migrations.GameBelongsToOpponent do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :opponent_id, :id
    end
  end
end
