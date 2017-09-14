defmodule CodeCorps.Helpers.Query do
  import CodeCorps.Helpers.String, only: [coalesce_id_string: 1]
  import Ecto.Query, only: [where: 3, limit: 2, order_by: 2]

  @spec id_filter(Ecto.Queryable.t, map | String.t) :: Ecto.Queryable.t
  def id_filter(query, %{"filter" => %{"id" => id_csv}}) do
    query |> id_filter(id_csv)
  end
  def id_filter(query, %{}), do: query
  def id_filter(query, id_list) when is_binary(id_list) do
    ids = id_list |> coalesce_id_string
    query |> where([object], object.id in ^ids)
  end

  # skill queries

  def limit_filter(query, %{"limit" => count}), do: query |> add_limit(count |> Integer.parse)
  def limit_filter(query, _), do: query

  defp add_limit(query, {count, _rem}), do: query |> limit(^count)
  defp add_limit(query, _other), do: query

  def title_filter(query, %{"query" => title}) do
    query |> where([object], ilike(object.title, ^"%#{title}%"))
  end
  def title_filter(query, _), do: query

  # end skill queries

  # task queries

  def project_filter(query, %{"project_id" => project_id}) do
    query |> where([object], object.project_id == ^project_id)
  end
  def project_filter(query, _), do: query

  # end task queries

  # def comment queries

  def task_filter(query, task_id) do
    query |> where([object], object.task_id == ^task_id)
  end

  # end comment queries

  # user queries

  def user_filter(query, %{"query" => query_string}) do
    query
    |> where(
      [object],
      ilike(object.first_name, ^"%#{query_string}%") or
      ilike(object.last_name, ^"%#{query_string}%") or
      ilike(object.username, ^"%#{query_string}%")
    )
  end
  def user_filter(query, _), do: query

  # end user queries

  # sorting

  def sort_by_newest_first(query), do: query |> order_by([desc: :inserted_at])

  def sort_by_order(query), do: query |> order_by([asc: :order])

  # end sorting

  # finders

  def slug_finder(query, slug) do
    query |> CodeCorps.Repo.get_by(slug: slug |> String.downcase)
  end

  # end finders
end
