defmodule VisitedDomains.LinksControllerTest do
  use ExUnit.Case
  use Plug.Test

  import Mox

  alias VisitedDomains.LinksController

  describe "post /visited_links" do
    test "returns 200 with correct params" do
      redis_response = {:ok, "google.com;ya.ru;1545221235" }
      Redix |> expect(:command, fn(_conn, _options) -> redis_response end)
      data = %{
        "links" => ["google.ru", "ya.ru"]
      }

      conn =
        :post
        |> conn("/visited_links")
        |> LinksController.create(data)

      assert conn.status == 200
    end

    test "returns 422 when data saving is failed" do
      redis_response = {:error, %{message: "connection error"}}
      Redix |> expect(:command, fn(_, _) -> redis_response end)
      data = %{
        "links" => ["google.ru", "ya.ru"]
      }

      conn =
        :post
        |> conn("/visited_links")
        |> LinksController.create(data)

      assert conn.status == 422
    end

    test "returns 422 when params are not passed" do
      redis_response = {:ok, "google.com;ya.ru;1545221235" }
      Redix |> expect(:command, fn(_, _) -> redis_response end)
      data = %{}

      conn =
        :post
        |> conn("/visited_links")
        |> LinksController.create(data)

      assert conn.status == 422
    end
  end
end
