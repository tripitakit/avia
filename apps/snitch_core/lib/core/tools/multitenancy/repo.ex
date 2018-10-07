defmodule Snitch.Core.Tools.MultiTenancy.Repo do
  @moduledoc """
    Alternative Repo to support multi tenancy.
    By default, all functions will insert :prefix in options.
  """

  alias Snitch.Repo

  def get(arg1, arg2), do: Repo.get(arg1, arg2, get_opts())

  def get!(arg1, arg2), do: Repo.get(arg1, arg2, get_opts())

  def get_by(arg1, arg2), do: Repo.get_by(arg1, arg2, get_opts())

  def get_by!(arg1, arg2), do: Repo.get_by!(arg1, arg2, get_opts())

  def one(args), do: Repo.one(args, get_opts())

  def one!(args), do: Repo.one!(args, get_opts())

  def insert(arg1, arg2 \\ []), do: Repo.insert(arg1, arg2 ++ get_opts())

  def insert!(args), do: Repo.insert!(args, get_opts())

  def insert_all(arg1, arg2, arg3 \\ []), do: Repo.insert_all(arg1, arg2, arg3 ++ get_opts())

  def update(args), do: Repo.update(args, get_opts())

  def update!(args), do: Repo.update!(args, get_opts())

  def load(arg1, arg2), do: Repo.load(arg1, arg2)

  def load(arg1, arg2, _), do: Repo.load(arg1, arg2)

  def update_all(arg1, arg2), do: Repo.update_all(arg1, arg2, get_opts())

  def delete(args), do: Repo.delete(args, get_opts())

  def delete_all(args), do: Repo.delete_all(args, get_opts())

  def all(args), do: Repo.all(args, get_opts())

  def transaction(arg1, arg2 \\ []), do: Repo.transaction(arg1, arg2 ++ get_opts())

  def rollback(args), do: Repo.rollback(args)

  def preload(arg1, arg2), do: Repo.preload(arg1, arg2)

  def preload(arg1, arg2, arg3), do: Repo.preload(arg1, arg2, arg3)

  def set_tenant(tenant) do
    Process.put({__MODULE__, :prefix}, tenant)
    tenant
  end

  # Private

  defp get_opts() do
    [prefix: Process.get({__MODULE__, :prefix})]
  end
end
