defmodule VisitedDomains.ParseDomainsTest do
  use ExUnit.Case

  alias VisitedDomains.ParseDomains

  @link_list [
    "https://ya.ru?q=123",
    "funbox.ru",
    "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
  ]

  test "parses domains" do
    {:ok, result} = ParseDomains.execute(@link_list)
    assert result == ["ya.ru", "funbox.ru", "stackoverflow.com"]
  end
end
