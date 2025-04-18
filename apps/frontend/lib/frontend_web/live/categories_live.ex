defmodule FrontendWeb.CategoriesLive do
  use FrontendWeb, :live_view

  def mount(params, session, socket) do
    {:ok, assign(socket, categories: [])}
  end

  def render(assigns) do
    ~H"""
    Categories! {@categories}
    """
  end
end
