defmodule Snitch.Core.Tools.MultiTenancy.Tenant do

  alias Ecto.Adapters.SQL
  alias Snitch.Repo

  def create(tenant_name) do
    sql = "CREATE SCHEMA \"#{tenant_name}\""
    SQL.query(Repo, sql, [])
    run_migrations(:up, tenant_name)
  end

  def drop(tenant_name) do
    sql = "DROP SCHEMA \"#{tenant_name}\""
    SQL.query(Repo, sql, [])
    run_migrations(:down, tenant_name)
  end

  # Private

  defp run_migrations(direction, prefix) do
    Code.compiler_options(ignore_module_conflict: true)
    Ecto.Migrator.run(
      Repo,
      get_migrations(),
      direction,
      [all: true, prefix: prefix, log: false]
    )
    {:ok, "migrations complete"}
  end

  defp get_migrations() do
    Path.wildcard("priv/repo/migrations/*.exs")
    |> Enum.map(fn file ->
      migration_module = load_module(file)
      if migration_eligible?(migration_module), do:
        {
          extract_version(file),
          migration_module
        }
    end)
    |> Enum.filter(& !is_nil(&1))
  end

  defp migration_eligible?(module) do
    not(module.__info__(:functions)
    |> Keyword.keys()
    |> Enum.member?(:skip_for_multitenancy))
  end

  defp extract_version(path) do
    Regex.run(~r/[0-9]{14}/, path)
    |> List.first
    |> String.to_integer(10)
  end

  defp load_module(path) do
    Code.load_file(path)
    |> List.first
    |> Tuple.to_list
    |> List.first
  end

end
