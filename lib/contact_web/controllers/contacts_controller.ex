defmodule ContactWeb.ContactsController do
  use ContactWeb, :controller
  

  def get_query_param(conn, param) do
    case conn.query_params do
      %{^param => p} ->
        p
      _ ->
        ""
    end
  end

  def contacts(conn, _params) do
    q = get_query_param(conn, "q")
    render(conn, :contacts, contacts:
      case Integer.parse(q) do
        {id, ""} ->
          Enum.filter(Contact.Repo.all(Contact.Contact), fn contact -> contact.id == id end)
        _ ->
          Contact.Repo.all(Contact.Contact)
      end
    )
  end

  def contacts_new_get(conn, _params) do
    render(conn, :contacts_new, contact: Map.merge(%Contact.Contact{}, %{errors: %{}}))
  end
  
  def contacts_new_post(conn, %{"email" => email,
                                "phone" => phone,
                                "first_name" => first,
                                "last_name" => last} \\ %{}) do
    params = %{
      email: email,
      phone: phone,
      first: first,
      last: last}
    contact = try do %Contact.Contact{} |> Contact.Contact.changeset(params)
              rescue
                KeyError ->
                  Contact.Contact.create_contact(params)
              end
    case contact |> Contact.Repo.insert do
      {:ok, response} ->
        conn
        |> put_flash(:info, "#{response.email} created!")
        |> redirect(to: ~p"/contacts")
      {:error, response} ->
        errors = response.errors |> Enum.into(%{}, fn {k, v} -> {k, v |> elem(0)} end)
        conn
        |> put_flash(:error, "Error registering contact!")
        |> render(:contacts_new, contact: Map.merge(Contact.Contact.create_contact(response.changes), %{errors: errors}))
    end
  end

  def contacts_view(conn, %{"id" => id}) do
    render(conn, :contacts_view, contact: Contact.Repo.get(Contact.Contact, id))
  end

  def contacts_edit(conn, %{"id" => id}) do
    render(conn, :contacts_edit, contact: Map.merge(Contact.Repo.get(Contact.Contact, id), %{errors: %{}}))
  end

  def contacts_edit_post(conn, %{"email" => email,
                                 "phone" => phone,
                                 "first_name" => first,
                                 "last_name" => last,
                                 "id" => id}) do
    contact = Contact.Repo.get(Contact.Contact, id)
    attrs = %{
      email: email,
      phone: phone,
      first: first,
      last: last,
      id: id
    }
    contact_changeset = Contact.Contact.changeset(contact, attrs)
    case Contact.Repo.update(contact_changeset) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Updated Contact!")
        |> redirect(to: ~p"/contacts/#{contact.id}")
      {:error, response} ->
        errors = response.errors |> Enum.into(%{}, fn {k, v} -> {k, v |> elem(0)} end)
        conn
        |> put_flash(:error, "Error updating contact!")
        |> render(:contacts_edit, contact: Map.merge(attrs, %{errors: errors}))
    end
  end

  def contacts_delete(conn, %{"id" => id}) do
    case Contact.Repo.delete(Contact.Repo.get(Contact.Contact, id)) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Deleted Contact!")
        |> put_status(303)
        |> redirect(to: ~p"/contacts")
      {:error, _response} ->
        conn
        |> put_flash(:error, "Could not delete contact")
        |> put_status(303)
        |> redirect(to: ~p"/contacts/#{id}")
    end
  end
end
