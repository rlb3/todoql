defmodule Todo.Authentication do
  @behaviour Absinthe.Middleware
  @moduledoc false
  
  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} -> resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
    end
  end
end
