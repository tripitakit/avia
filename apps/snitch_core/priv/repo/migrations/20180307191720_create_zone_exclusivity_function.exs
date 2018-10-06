defmodule Snitch.Repo.Migrations.CreateZoneExclusivityFunction do
  use Ecto.Migration

  def skip_for_multitenancy, do: true

  @zone_exclusivity_fn ~s"""
  create function zone_exclusivity(
    in supertype_id bigint,
    in subtype_discriminator varchar(1)
    )
  returns integer
  as $$
    select coalesce(
      (select 1
        from  snitch_zones
        where id = supertype_id
        and   zone_type = subtype_discriminator),
      0)
  $$
  language sql;
  """

  def change do
    execute @zone_exclusivity_fn, "drop function zone_exclusivity;"
  end
end
