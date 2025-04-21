defmodule FinancesWeb.CategoriesListLive do
  alias Finances.Categories.Services.CrudOperationsService
  use FinancesWeb, :live_view

  def mount(_params, _session, socket) do
    categories = CrudOperationsService.list()
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    List of categories here
    """
  end
end
