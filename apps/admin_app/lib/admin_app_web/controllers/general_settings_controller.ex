defmodule AdminAppWeb.GeneralSettingsController do
    use AdminAppWeb, :controller
    alias Snitch.Tools.OrderEmail
    alias Snitch.Data.Schema.Order
    alias Snitch.Repo

    def new(conn, _params) do
      render(conn, "new.html")
    end

    def create(conn, %{"settings" =>  %{"email" => email, "sendgrid_api_key" => sendgrid_api_key}}) do
     
      Application.put_env(:snitch_core, Snitch.Tools.Mailer, [sendgrid_sender_mail: email, api_key: sendgrid_api_key, adapter: Bamboo.SendGridAdapter])
      orders = Repo.all(Order)
      order = orders |> List.first()
      response = OrderEmail.order_confirmation_mail(order)
      conn
        |> put_flash(:info, "Email sent")
        |> render(conn, "new.html")
    end
end
