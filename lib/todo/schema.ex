defmodule Todo.Schema do
  use Absinthe.Schema
  import_types Todo.Schema.Types

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve &Todo.UserResolver.all/2
    end

    @desc "Get current user"
    field :me, :user do
      resolve &Todo.UserResolver.me/2
    end

    @desc "Get todo items for the current user"
    field :items, list_of(:item) do
      arg :show_all, :boolean, default_value: false

      resolve &Todo.ItemResolver.all/2
    end
  end

  mutation do
    @desc "Password Authentication"
    field :login, type: :session do
      arg :email, non_null(:string), description: "User's email"
      arg :password, non_null(:string), description: "User's password"

      resolve &Todo.UserResolver.login/2
    end

    @desc "Register a user"
    field :register, type: :session do
      arg :name, :string, description: "The users name"
      arg :email, :string, description: "The users email"
      arg :password, :string, description: "Thes users password"

      resolve &Todo.UserResolver.register/2
    end

    @desc "Add todo for the current user"
    field :add_todo, type: :item do
      arg :title, non_null(:string), description: "Todo's title"

      resolve &Todo.ItemResolver.create/2
    end

    @desc "Update the todo's title"
    field :update_title, type: :item do
      arg :id, :id, description: "The todo's ID"
      arg :title, :string, description: "The todo's title"

      resolve &Todo.ItemResolver.update_title/2
    end

    @desc "Mark todo as done"
    field :mark_done, type: :item do
      arg :id, :id, description: "The todo's ID"

      resolve &Todo.ItemResolver.mark_done/2
    end
  end

  def middleware(middleware, %Absinthe.Type.Field{identifier: :login}, _object) do
    middleware
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: id}) do
    if Enum.member?([:query, :mutation], id) do
      [Todo.Authentication | middleware]
    else
      middleware
    end
  end
end
