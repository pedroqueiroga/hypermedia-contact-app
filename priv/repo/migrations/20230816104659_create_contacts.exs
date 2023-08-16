defmodule Contact.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :first, :string
      add :last, :string
      add :email, :string
      add :phone, :string

      timestamps()
    end
  end
end
