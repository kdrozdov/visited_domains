defmodule VisitedDomains.DomainsRepositoryTest do
  use ExUnit.Case

  import Mox

  alias VisitedDomains.DomainsRepository

  setup :verify_on_exit!

  describe "find_visited_domains" do
    test "returns visited domains" do
      redis_response = "google.com;ya.ru;funbox.com;1545221235"
      Redix |> expect(:command, fn(_conn, _command) -> {:ok, [redis_response] } end)

      {:ok, result} = DomainsRepository.find_visited_domains("1545221234", "1545221238")
      assert result == ["funbox.com", "google.com", "ya.ru"]
    end
  end
end
