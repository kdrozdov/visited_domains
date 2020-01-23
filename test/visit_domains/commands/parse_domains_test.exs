defmodule VisitedDomains.ParseDomainsTest do
  use ExUnit.Case

  @link_list [
    "https://ya.ru?q=123",
    "funbox.ru",
    "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
  ]

  test "parses domains" do
    {:ok, result} = VisitedDomains.ParseDomains.execute(@link_list)
    assert result == ["ya.ru", "funbox.ru", "stackoverflow.com"]
  end
end
