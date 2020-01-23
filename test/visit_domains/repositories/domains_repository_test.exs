defmodule VisitedDomains.DomainsRepositoryTest do
  use ExUnit.Case

  import Mox

  alias VisitedDomains.DomainsRepository

  setup :verify_on_exit!

  test "finds visited domains" do
    stored_domains = "google.com;ya.ru;funbox.com;1545221235"
    Redix |> expect(:command, fn(_conn, _command) -> {:ok, [stored_domains] } end)

    {:ok, result} = DomainsRepository.find_visited_domains("1545221234", "1545221238")
    assert result == ["funbox.com", "google.com", "ya.ru"]
  end
end
