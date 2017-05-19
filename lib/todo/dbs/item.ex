defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "items" do
    field :completed, :boolean, default: false
    field :title, :string
    belongs_to :user, Todo.User

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:title, :completed])
    |> validate_required([:title])
  end
end
