defmodule Clash.CountsTest do
  use Clash.DataCase

  alias Clash.Counts

  describe "counts" do
    alias Clash.Counts.Count

    import Clash.CountsFixtures

    @invalid_attrs %{}

    test "list_counts/0 returns all counts" do
      count = count_fixture()
      assert Counts.list_counts() == [count]
    end

    test "get_count!/1 returns the count with given id" do
      count = count_fixture()
      assert Counts.get_count!(count.id) == count
    end

    test "create_count/1 with valid data creates a count" do
      valid_attrs = %{}

      assert {:ok, %Count{} = count} = Counts.create_count(valid_attrs)
    end

    test "create_count/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Counts.create_count(@invalid_attrs)
    end

    test "update_count/2 with valid data updates the count" do
      count = count_fixture()
      update_attrs = %{}

      assert {:ok, %Count{} = count} = Counts.update_count(count, update_attrs)
    end

    test "update_count/2 with invalid data returns error changeset" do
      count = count_fixture()
      assert {:error, %Ecto.Changeset{}} = Counts.update_count(count, @invalid_attrs)
      assert count == Counts.get_count!(count.id)
    end

    test "delete_count/1 deletes the count" do
      count = count_fixture()
      assert {:ok, %Count{}} = Counts.delete_count(count)
      assert_raise Ecto.NoResultsError, fn -> Counts.get_count!(count.id) end
    end

    test "change_count/1 returns a count changeset" do
      count = count_fixture()
      assert %Ecto.Changeset{} = Counts.change_count(count)
    end
  end
end
