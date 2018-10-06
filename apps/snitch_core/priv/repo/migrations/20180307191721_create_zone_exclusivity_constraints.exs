defmodule Snitch.Repo.Migrations.CreateZoneExclusivityConstraints do
  use Ecto.Migration

  def change do
    create constraint("snitch_state_zone_members", :state_zone_exclusivity, check: "zone_exclusivity(zone_id, 'S') = 1")
    create constraint("snitch_country_zone_members", :country_zone_exclusivity, check: "zone_exclusivity(zone_id, 'C') = 1")
  end
end
