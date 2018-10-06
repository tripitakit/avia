defmodule Snitch.Core.Tools.MultiTenancy.Utils do

  alias Snitch.Core.Tools.MultiTenancy.Repo


  def tenant_handler(tenant) do
    if not is_nil(tenant), do: extract_subdomain(tenant)
  end

  defp extract_subdomain(host) do
    hosts = String.split(host, ".")
    tenant = List.first(hosts)
    if length(hosts) > 2 and not Triplex.reserved_tenant?(tenant), do:
      Repo.set_tenant(tenant)
  end

end
