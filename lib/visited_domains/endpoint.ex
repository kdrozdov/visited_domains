defmodule VisitedDomains.Endpoint do
  use Plug.Router

  alias Plug.Cowboy

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  require Logger

  forward("/", to: VisitedDomains.Router)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    port = 4000
    Logger.info("Starting server at http://localhost:#{port}/")
    Cowboy.http(__MODULE__, [{:port, port}])
  end
end
