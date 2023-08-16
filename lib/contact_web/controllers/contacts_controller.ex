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
    render(conn, :contacts, layout: false, contacts:
      case Integer.parse(q) do
        {id, ""} ->
          Enum.filter(Contact.Repo.all(Contact.Contact), fn contact -> contact.id == id end)
        _ ->
          Contact.Repo.all(Contact.Contact)
      end
    )
  end

  def contacts_new_get(conn, _params) do
    render(conn, :contacts_new, layout: false, contact: Map.merge(%Contact.Contact{}, %{errors: %{}}))
  end
  
  def contacts_new_post(conn, %{"email" => email,
                                "phone" => phone,
                                "first_name" => first,
                                "last_name" => last}) do
    case Contact.Repo.insert(%Contact.Contact{
              email: email,
              phone: phone,
              first: first,
              last: last}) do
      {:ok, response} ->
        conn
        |> put_flash(:info, "#{response.email} created!")
        |> redirect(to: ~p"/contacts")
      {:error, response} ->
        render(conn, :contacts_new, layout: false, contact: response)
    end
  end

  def contacts_view(conn, %{"id" => id}) do
    render(conn, :contacts_view, layout: false, contact: Contact.Repo.get(Contact.Contact, id))
  end

  def contacts_edit(conn, %{"id" => id}) do
    render(conn, :contacts_edit, layout: false, contact: Map.merge(Contact.Repo.get(Contact.Contact, id), %{errors: %{}}))
  end

  def contacts_edit_post(conn, %{"email" => email,
                                 "phone" => phone,
                                 "first_name" => first,
                                 "last_name" => last,
                                 "id" => id}) do
    contact = Contact.Repo.get(Contact.Contact, id)
    contact_changeset = Contact.Contact.changeset(contact, %{
          email: email,
          phone: phone,
          first: first,
          last: last,
          id: id})
    case Contact.Repo.update(contact_changeset) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Updated Contact!")
        |> redirect(to: ~p"/contacts/#{contact.id}")
      {:error, response} ->
        render(conn, :contacts_edit, layout: false, contact: response)
    end
  end

  def contacts_delete(conn, %{"id" => id}) do
    case Contact.Repo.delete(Contact.Repo.get(Contact.Contact, id)) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Deleted Contact!")
        |> redirect(to: ~p"/contacts")
      {:error, _response} ->
        conn
        |> put_flash(:error, "Could not delete contact")
        |> redirect(to: ~p"/contacts/#{id}")
    end
  end
end
