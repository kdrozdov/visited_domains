defmodule VisitedDomains.DomainsController do
  import Plug.Conn

  alias VisitedDomains.DomainsRepository

  def index(conn, params) do
    with {:ok} <- validate_params(params),
         {:ok, domains} <- find_domains(params) do
      conn |> send_resp(200, Jason.encode!(%{domains: domains, status: "ok"}))
    else
      {:error, error} ->
        conn |> send_resp(422, Jason.encode!(%{status: error.message}))

      _ ->
        conn |> send_resp(422, Jason.encode!(%{status: "error"}))
    end
  end

  defp find_domains(params) do
    DomainsRepository.find_visited_domains(params["from"], params["to"])
  end

  defp validate_params(params) do
    required_keys = ["from", "to"]

    with true <- Enum.all?(required_keys, fn key -> params[key] != nil end),
         {_num, _} <- Integer.parse(params["from"]),
         {_num, _} <- Integer.parse(params["to"]) do
      {:ok}
    else
      _ -> {:error, %{message: "invalid params"}}
    end
  end
end
