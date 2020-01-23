defmodule VisitedDomains.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/visited_links" do
    conn
    |> put_resp_content_type("application/json")
    |> VisitedDomains.LinksController.create(conn.body_params)
  end

  get "/visited_domains" do
    conn
    |> put_resp_content_type("application/json")
    |> VisitedDomains.DomainsController.index(conn.query_params)
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
