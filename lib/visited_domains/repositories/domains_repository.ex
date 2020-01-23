defmodule VisitedDomains.DomainsRepository do
  @set_name "visits_set"

  def save(domain_list, time) do
    key = create_data_key(domain_list, time)
    Redix.command(:redix, ["ZADD", @set_name, time, key])
  end

  def find_visited_domains(from, to) do
    case Redix.command(:redix, ["ZRANGEBYSCORE", @set_name, from, to]) do
      {:ok, results} -> combine_results(results, MapSet.new())
      {:error, error} -> {:error, error}
    end
  end

  defp combine_results([head | tail], map_set) do
    restored_results =
      head
      |> restore_data_from_key
      |> MapSet.new()

    combine_results(tail, MapSet.union(map_set, restored_results))
  end

  defp combine_results([], map_set) do
    {:ok, MapSet.to_list(map_set)}
  end

  defp create_data_key(list, time) do
    data = Enum.join(list, ";")
    "#{data};#{time}"
  end

  defp restore_data_from_key(key) do
    key
    |> String.split(";")
    |> Enum.drop(-1)
  end
end
