defmodule Todo.ItemResolver do
  alias Todo.{Repo, Item, User}
  import Ecto.Query

  @moduledoc false

  def all(%{show_all: show_all}, %{context: %{current_user: user}}) do
    case show_all do
      true ->
        user = user |> Repo.preload(:items)
        {:ok, user.items}
      _ ->
        query = from u in User,
          where: u.id == ^user.id,
          join: i in assoc(u, :items),
          where: i.completed == false,
          select: i
        {:ok, Repo.all(query)}
    end
  end

  def create(args, %{context: %{current_user: user}}) do
    user
    |> Ecto.build_assoc(:items)
    |> Item.changeset(args)
    |> Repo.insert
  end

  def update_title(args, %{context: %{current_user: _user}}) do
    Item
    |> Repo.get(args.id)
    |> Item.changeset(args)
    |> Repo.update
  end

  def mark_done(%{id: id}, %{context: %{current_user: _user}}) do
    Item
    |> Repo.get(id)
    |> Item.changeset(%{completed: true})
    |> Repo.update
  end

  def delete(%{id: id}, %{context: %{current_user: user}}) do
    query = from i in Item,
      where: i.id == ^id,
      where: i.user_id == ^user.id,
      limit: 1

      query
      |> Repo.one
      |> Repo.delete
  end
end
