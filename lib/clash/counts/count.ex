defmodule Clash.Counts.Count do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counts" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(count, attrs) do
    count
    |> cast(attrs, [])
    |> validate_required([])
  end
end
