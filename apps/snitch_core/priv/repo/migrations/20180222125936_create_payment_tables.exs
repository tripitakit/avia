defmodule Core.Repo.Migrations.CreatePaymentTables do
  use Ecto.Migration

  def change do
    create table("snitch_payment_methods") do
      add :name, :string, null: :false
      add :code, :char, size: 3
      add :active?, :boolean, default: true, null: :false
      timestamps()
    end
    create unique_index("snitch_payment_methods", :code)

    create table("snitch_payments", comment: "payment supertype") do
      add :payment_method_id, references("snitch_payment_methods"), null: false
      add :payment_type, :char, size: 3, comment: "discriminator", null: false
      add :slug, :string, null: false
      add :amount, :money_with_currency
      add :state, :string, default: "pending"
      add :order_id, references("snitch_orders"), null: false
      timestamps()
    end
    create unique_index("snitch_payments", :slug)

    create table("snitch_card_payments", comment: "payments made via credit or debit cards") do
      add :payment_id, references("snitch_payments", on_delete: :delete_all), null: false
      add :response_code, :string
      add :response_message, :text
      add :avs_response, :string
      add :cvv_response, :string
      timestamps()
    end
    create unique_index("snitch_card_payments", :payment_id, comment: "one-to-one relationship")

  end
end
