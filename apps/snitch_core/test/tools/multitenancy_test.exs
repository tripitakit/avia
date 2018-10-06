defmodule Snitch.Tools.MultiTenancyTest do
  use ExUnit.Case
  use Snitch.DataCase
  alias Snitch.Core.Tools.MultiTenancy.Tenant


  test "create tenant" do
    assert Triplex.create("amazon") == {:ok, "amazon"}
    assert Triplex.drop("amazon") == {:ok, "amazon"}
  end

end
