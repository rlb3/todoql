defmodule Todo.Web.Router do
  use Todo.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Todo.Web.Context
  end

  scope "/" do
    pipe_through :graphql

    forward "/api", Absinthe.Plug,
      schema: Todo.Schema

    if Mix.env in [:dev, :qa] do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: Todo.Schema
    end
  end
end
