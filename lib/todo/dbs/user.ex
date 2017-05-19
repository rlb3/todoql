defmodule Todo.User do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :items, Todo.Item

    timestamps()
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email], [:password])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> downcase_email
    |> put_pass_hash()
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> downcase_email()
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp downcase_email(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} ->
        put_change(changeset, :email, String.downcase(email))
      _ ->
        changeset
    end
  end
end
