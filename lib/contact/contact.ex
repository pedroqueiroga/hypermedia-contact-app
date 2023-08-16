defmodule Contact.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :first, :string
    field :last, :string
    field :email, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first, :last, :email, :phone])
    |> validate_required([:first, :last, :email, :phone])
  end
end
