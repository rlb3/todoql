defmodule Todo.Web.Context do
  @behaviour Plug
  @moduledoc false

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil -> conn
      user ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
    end
  end
end
