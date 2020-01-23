defmodule VisitedDomains.ParseDomains do
  @scheme_regex ~r/^http[s]?:\/\/*/
  @default_scheme "https://"

  def execute(nil), do: {:error, %{message: "argument can't be nil"}}

  def execute(link_list) do
    try do
      domains =
        link_list
        |> Enum.map(&add_missing_sheme/1)
        |> Enum.map(&parse_link/1)
        |> Enum.filter(&(&1 != ""))
      {:ok, domains}
    rescue
      e in RuntimeError -> {:error, e.message}
    end
  end

  defp parse_link(link) do
    URI.parse(link).host
  end

  defp add_missing_sheme(link) do
    if Regex.match?(@scheme_regex, link) do
      link
    else
      "#{@default_scheme}#{link}"
    end
  end
end
