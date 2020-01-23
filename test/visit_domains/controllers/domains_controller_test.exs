defmodule VisitedDomains.DomainsControllerTest do
  use ExUnit.Case
  use Plug.Test

  import Mox

  alias VisitedDomains.DomainsController

  describe "get /visited_domains" do
    test "returns 200 with correct params" do
      redis_response = "google.com;ya.ru;habr.ru;1545221235"
      Redix |> expect(:command, fn(_conn, _command) -> {:ok, [redis_response] } end)
      params = %{"from" => "1545221232", "to" => "1545221238"}

      conn =
        :get
        |> conn("/visited_domains")
        |> DomainsController.index(params)

      expected_response = %{
        "domains" => [
          "google.com",
          "habr.ru",
          "ya.ru"
        ],
        "status" => "ok"
      }

      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(expected_response)
    end

    test "returns 422 with invalid params" do
      redis_response = "google.com;ya.ru;habr.ru;1545221235"
      Redix |> expect(:command, fn(_conn, _command) -> {:ok, [redis_response] } end)
      params = %{"from" => "invalid", "to" => "1545221238"}

      conn =
        :get
        |> conn("/visited_domains")
        |> DomainsController.index(params)

      expected_response = %{"status" => "invalid params"}

      assert conn.status == 422
      assert conn.resp_body == Jason.encode!(expected_response)
    end

    test "returns 422 when redis error occurs" do
      redis_response = {:error, %{message: "connection error"}}
      Redix |> expect(:command, fn(_, _) -> redis_response end)
      params = %{"from" => "1545221232", "to" => "1545221238"}

      conn =
        :get
        |> conn("/visited_domains")
        |> DomainsController.index(params)

      expected_response = %{"status" => "connection error"}

      assert conn.status == 422
      assert conn.resp_body == Jason.encode!(expected_response)
    end
  end
end
