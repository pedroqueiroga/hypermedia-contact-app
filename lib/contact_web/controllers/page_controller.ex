defmodule ContactWeb.PageController do
  use ContactWeb, :controller

  def home(conn, _params) do
    conn
    |> redirect(to: ~p"/contacts")
  end
end
