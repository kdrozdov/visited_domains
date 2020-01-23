defmodule VisitedDomains.LinksController do
  import Plug.Conn

  def create(conn, params) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()

    with {:ok, domains} <- VisitedDomains.ParseDomains.execute(params["links"]),
         {:ok, _} <- VisitedDomains.DomainsRepository.save(domains, timestamp) do
      conn |> send_resp(200, Jason.encode!(%{status: "ok"}))
    else
      {:error, error} ->
        conn |> send_resp(422, Jason.encode!(%{status: error.message}))

      _ ->
        conn |> send_resp(422, Jason.encode!(%{status: "error"}))
    end
  end
end
