defmodule VisitedDomains.Redis.ClientBehaviour do
  @type command() :: [String.Chars.t()]
  @type connection() :: GenServer.server()

  @callback command(connection(), command()) ::
    {:ok, result :: term} | {:error, reason :: term}
end
