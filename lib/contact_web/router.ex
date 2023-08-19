defmodule ContactWeb.Router do
  use ContactWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ContactWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ContactWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/contacts", ContactsController, :contacts
    get "/contacts/new", ContactsController, :contacts_new_get
    post "/contacts/new", ContactsController, :contacts_new_post
    get "/contacts/:id", ContactsController, :contacts_view
    get "/contacts/:id/edit", ContactsController, :contacts_edit
    post "/contacts/:id/edit", ContactsController, :contacts_edit_post
    delete "/contacts/:id", ContactsController, :contacts_delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", ContactWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:contact, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ContactWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
