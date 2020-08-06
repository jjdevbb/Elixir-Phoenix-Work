defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Front-End
  scope "/", HelloWeb do
    pipe_through :browser
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    get "/", PageController, :index
    
    resources "/users", UserController
    resources "/reviews", ReviewController
    resources "/comments", CommentController, except: [:delete]
  end

  # Admin
  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser
    resources "/images", ImageController
    resources "/reviews", ReviewController
    resources "/users", UserController
  end

  # API
  scope "/api", HelloWeb.Api, as: :api do
    pipe_through :browser
    scope "/v1", V1, as: :v1 do
      resources "/images", ImageController
      resources "/reviews", ReviewController
      resources "/users", UserController
    end
  end
  
  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end
end
