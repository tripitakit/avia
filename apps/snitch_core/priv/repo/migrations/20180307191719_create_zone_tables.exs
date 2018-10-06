defmodule Snitch.Repo.Migrations.CreateZoneTables do
  use Ecto.Migration

  def change do
    create table("snitch_zones") do
      add :name, :string, null: :false
      add :zone_type, :string, size: 1, null: false, comment: "discriminator"
      add :description, :text, null: false
      timestamps()
    end
    create constraint("snitch_zones", :valid_zone_type, check: "zone_type = any(array['S', 'C'])")

    create table("snitch_state_zone_members") do
      add :state_id, references("snitch_states", on_delete: :delete_all), null: false
      add :zone_id, references("snitch_zones", on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index("snitch_state_zone_members", [:zone_id, :state_id])

    create table("snitch_country_zone_members") do
      add :country_id, references("snitch_countries", on_delete: :delete_all), null: false
      add :zone_id, references("snitch_zones", on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index("snitch_country_zone_members", [:zone_id, :country_id])

  end
end
