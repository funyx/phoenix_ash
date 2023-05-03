defmodule PhoenixAshWeb.Router do
  use PhoenixAshWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PhoenixAshWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:load_from_session)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:load_from_bearer)
  end

  scope "/", PhoenixAshWeb do
    # ash_authentication_live_session :authentication_required,
    #   on_mount: {PhoenixAshWeb.UserAuth, :live_user_required} do
    #   live("/protected_route", ProjectLive.Index, :index)
    # end

    # ash_authentication_live_session :authentication_optional,
    #   on_mount: {PhoenixAshWeb.UserAuth, :live_user_optional} do
    #   live("/", ProjectLive.Index, :index)
    # end

    pipe_through(:browser)

    get("/", PageController, :home)

    sign_in_route(on_mount: [{PhoenixAshWeb.UserAuth, :live_no_user}])
    sign_out_route(AuthController)
    auth_routes_for(PhoenixAsh.Account.User, to: AuthController)
    reset_route([])
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixAshWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:phoenix_ash, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: PhoenixAshWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
