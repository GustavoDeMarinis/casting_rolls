defmodule CastingRollsWeb.Router do
  use CastingRollsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CastingRollsWeb.Plugs.AuthPlug
  end

  scope "/api", CastingRollsWeb do
    pipe_through :api
    post "/signup", UserController, :create
    post "/signin", SessionController, :create
  end

  scope "/api", CastingRollsWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, except: [:new, :edit, :create]
    patch "/users/:id/password", UserController, :update_password

    resources "/rooms", RoomController, except: [:new, :edit]
    patch "/rooms/:id/password", RoomController, :update_password

    resources "/rolls", RollController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:casting_rolls, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CastingRollsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
