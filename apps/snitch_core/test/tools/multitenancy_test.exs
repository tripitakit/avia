defmodule Snitch.Tools.MultiTenancyTest do
  use ExUnit.Case
  use Snitch.DataCase
  alias Snitch.Core.Tools.MultiTenancy.Tenant


  test "create tenant" do
    {status, _} = Tenant.create("amazon")
    assert status == :ok
  end

end
