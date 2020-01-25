defmodule VisitedDomains.ParseDomainsTest do
  use ExUnit.Case

  alias VisitedDomains.ParseDomains

  @valid_list [
    "https://ya.ru?q=123",
    "funbox.ru",
    "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
  ]

  @invalid_list [
    "habr-.ru",
    "funbox.ru",
    "-habr.ru/test"
  ]

  test "parses domains" do
    {:ok, result} = ParseDomains.execute(@valid_list)
    assert result == ["ya.ru", "funbox.ru", "stackoverflow.com"]
  end

  test "skips invalid domains" do
    {:ok, result} = ParseDomains.execute(@invalid_list)
    assert result == ["funbox.ru"]
  end
end
