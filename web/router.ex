defmodule BackendPhoenix.Router do
  use BackendPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug GraphQL.Context
  end

  scope "/" do
    pipe_through :api
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: GraphQL.Schema
    forward "/graphql", Absinthe.Plug, schema: GraphQL.Schema
  end

  scope "/", BackendPhoenix do
    pipe_through :api
  end
end
