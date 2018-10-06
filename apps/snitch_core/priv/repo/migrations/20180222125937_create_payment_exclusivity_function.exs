defmodule Core.Repo.Migrations.CreatePaymentExclusivityFunction do
  use Ecto.Migration

  def skip_for_multitenancy, do: true

  @payment_exclusivity_fn ~s"""
  create function payment_exclusivity(
    in supertype_id bigint,
    in subtype_discriminator char(3)
    )
  returns integer
  as $$
    select coalesce(
      (select 1
        from  snitch_payments
        where id = supertype_id
        and   payment_type = subtype_discriminator),
      0)
  $$
  language sql;
  """

  def change do
    execute @payment_exclusivity_fn, "drop function payment_exclusivity;"
  end
end
