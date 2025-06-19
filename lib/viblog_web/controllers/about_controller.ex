defmodule ViblogWeb.AboutController do
  use ViblogWeb, :controller

  alias Viblog.About

  def index(conn, _params) do
    render(conn, :index, sections: About.all_sections())
  end
end
