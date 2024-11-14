defmodule Clash.CountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Clash.Counts` context.
  """

  @doc """
  Generate a count.
  """
  def count_fixture(attrs \\ %{}) do
    {:ok, count} =
      attrs
      |> Enum.into(%{

      })
      |> Clash.Counts.create_count()

    count
  end
end
