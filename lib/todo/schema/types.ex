defmodule Todo.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Todo.Repo

  @moduledoc false

  @desc "User object"
  object :user do
    field :id, :id
    field :name, :string, description: "The users name"
    field :email, :string, description: "The users email"
    field :items, list_of(:item), resolve: assoc(:items), description: "Users todo items"
  end

  @desc "Session object"
  object :session do
    field :token, :string, description: "JWT token"
  end

  @desc "Todo item"
  object :item do
    field :id, :id
    field :title, :string, description: "Todo title"
    field :completed, :boolean, description: "Whether the todo is completed"
    field :owner, :user, resolve: assoc(:user), description: "The owner of the todo"
  end

  @desc "Item filter"
  enum :item_filter do
    value :yes, as: :y, description: "All the Items"
    value :no, as: :n, description: "Only completed Items"
  end
end
