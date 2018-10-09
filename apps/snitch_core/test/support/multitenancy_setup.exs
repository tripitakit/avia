defmodule Snitch.Core.MultiTenancy.TestSetup do
  Application.put_env(:snitch, :multitenancy_test, enabled: true)
  Triplex.create("amazon")
end
