defmodule BackendPhoenix.Router do
  use BackendPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendPhoenix do
    pipe_through :api
  end
end
