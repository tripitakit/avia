defmodule Core.Repo.Migrations.AddMoneyWithCurrencyTypeToPostgres do
  use Ecto.Migration

  def skip_for_multitenancy, do: true

  def up do
    execute """
      CREATE TYPE public.money_with_currency AS (currency_code char(3), amount numeric(20,8))
    """
  end

  def down do
    execute "DROP TYPE public.money_with_currency"
  end
end
