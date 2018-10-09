defmodule Snitch.Core.Tools.MultiTenancy.Plug do
  alias Snitch.Core.Tools.MultiTenancy.Repo

  def init(options), do: options

  def call(%Plug.Conn{host: host} = conn, opts) do
    root_host = Keyword.get(opts, :endpoint).config(:url)[:host]

    if not root_domain?(host, root_host) do
      host
      |> tenant_exists?()
      |> set_repo(host)
      |> handle_conn(conn)
    else
      conn
    end
  end

  # Private

  defp root_domain?(host, root_host) do
    host in [root_host, "localhost", "0.0.0.0", "127.0.0.1"]
  end

  defp tenant_exists?(host) do
    host
    |> extract_subdomain()
    |> Triplex.exists?()
  end

  defp extract_subdomain(host) do
    String.split(host, ".")
    |> List.first()
  end

  defp set_repo(exists, host) do
    if exists,
      do:
        host
        |> extract_subdomain()
        |> Repo.set_tenant()

    exists
  end

  defp handle_conn(exists, %Plug.Conn{host: host} = conn) do
    reserved_tenant =
      host
      |> extract_subdomain()
      |> Triplex.reserved_tenant?()

    if !reserved_tenant and !exists do
      conn
      |> Plug.Conn.send_resp(:not_found, "Subdomain not found")
    else
      conn
    end
  end
end
