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

  def empty_str_if_nil(v) when v == nil do "" end
  def empty_str_if_nil(v) do v end

  def create_contact(attrs \\ %{}) do
    %{
      first: empty_str_if_nil(attrs[:first]),
      last: empty_str_if_nil(attrs[:last]),
      email: empty_str_if_nil(attrs[:email]),
      phone: empty_str_if_nil(attrs[:phone])
    }
  end
end
