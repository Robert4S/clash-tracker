defmodule Clash.Repo.Migrations.CreateCounts do
  use Ecto.Migration

  def change do
    create table(:counts) do

      timestamps(type: :utc_datetime)
    end
  end
end
