defmodule XFinancesWeb.Router do
  use XFinancesWeb, :router

  alias XFinancesWeb.Plugs.Auth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Auth
  end

  scope "/api", XFinancesWeb do
    pipe_through :api

    post "/authenticate", AuthController, :authenticate
  end

  scope "/api", XFinancesWeb do
    pipe_through [:api, :auth]

    resources "/categories", CategoriesController,
      only: [:index, :create, :update, :delete, :show]

    resources "/transactions", TransactionsController,
      only: [:index, :create, :update, :delete, :show]

    get "/dashboard_data", DashboardController, :get_dashboard_data
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:x_finances, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: XFinancesWeb.Telemetry
    end
  end
end
