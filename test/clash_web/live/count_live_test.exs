defmodule ClashWeb.CountLiveTest do
  use ClashWeb.ConnCase

  import Phoenix.LiveViewTest
  import Clash.CountsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_count(_) do
    count = count_fixture()
    %{count: count}
  end

  describe "Index" do
    setup [:create_count]

    test "lists all counts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/counts")

      assert html =~ "Listing Counts"
    end

    test "saves new count", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/counts")

      assert index_live |> element("a", "New Count") |> render_click() =~
               "New Count"

      assert_patch(index_live, ~p"/counts/new")

      assert index_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#count-form", count: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/counts")

      html = render(index_live)
      assert html =~ "Count created successfully"
    end

    test "updates count in listing", %{conn: conn, count: count} do
      {:ok, index_live, _html} = live(conn, ~p"/counts")

      assert index_live |> element("#counts-#{count.id} a", "Edit") |> render_click() =~
               "Edit Count"

      assert_patch(index_live, ~p"/counts/#{count}/edit")

      assert index_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#count-form", count: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/counts")

      html = render(index_live)
      assert html =~ "Count updated successfully"
    end

    test "deletes count in listing", %{conn: conn, count: count} do
      {:ok, index_live, _html} = live(conn, ~p"/counts")

      assert index_live |> element("#counts-#{count.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#counts-#{count.id}")
    end
  end

  describe "Show" do
    setup [:create_count]

    test "displays count", %{conn: conn, count: count} do
      {:ok, _show_live, html} = live(conn, ~p"/counts/#{count}")

      assert html =~ "Show Count"
    end

    test "updates count within modal", %{conn: conn, count: count} do
      {:ok, show_live, _html} = live(conn, ~p"/counts/#{count}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Count"

      assert_patch(show_live, ~p"/counts/#{count}/show/edit")

      assert show_live
             |> form("#count-form", count: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#count-form", count: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/counts/#{count}")

      html = render(show_live)
      assert html =~ "Count updated successfully"
    end
  end
end
