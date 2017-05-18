defmodule Todo.UserResolver do
  alias Todo.{Repo, User, Session}

  @moduledoc false

  def all(_args, %{context: %{current_user: _user}}) do
    {:ok, Repo.all(User)}
  end

  def me(_args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def login(args, _info) do
    with {:ok, user}   <- Session.authenticate(args, Repo),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt}}
    end
  end

  def register(args, _info) do
    status = %User{}
    |> User.registration_changeset(args)
    |> Repo.insert

    case status do
      {:ok, _user} -> login(args, %{})
      {:error, changeset} ->
        case changeset.errors do
          [email: {message, _}] ->
            {:error, message: "Email #{message}"}
        end
    end
  end
end
