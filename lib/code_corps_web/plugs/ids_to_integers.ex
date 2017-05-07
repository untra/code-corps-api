defmodule CodeCorpsWeb.Plug.IdsToIntegers do
  @moduledoc ~S"""
  Converts params in the JSON api "data" format into flat params convient for
  changeset casting.

  This is done using `JaSerializer.Params.to_attributes/1`
  """

  alias Plug.Conn

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Conn.t, Keyword.t) :: Plug.Conn.t
  def call(%Conn{params: %{} = params} = conn, _opts) do
    converted_params =
      params
      |> Enum.map(&convert_key_value/1)
      |> Enum.into(%{})

    conn |> Map.put(:params, converted_params)
  end
  def call(%Conn{} = conn, _opts), do: conn

  @spec convert_key_value(tuple) :: tuple
  defp convert_key_value({key, value}) do
    case key |> convert?() do
      true -> {key, value |> ensure_integer()}
      false -> {key, value}
    end
  end

  @spec convert?(any) :: boolean
  defp convert?("id"), do: true
  defp convert?("auth_token_id"), do: true
  defp convert?("category_id"), do: true
  defp convert?("comment_id"), do: true
  defp convert?("donation_goal_id"), do: true
  defp convert?("github_app_installation_id"), do: true
  defp convert?("github_repo_id_id"), do: true
  defp convert?("organization_github_app_installation_id"), do: true
  defp convert?("organization_invite_id"), do: true
  defp convert?("organization_id"), do: true
  defp convert?("preview_id"), do: true
  defp convert?("project_id"), do: true
  defp convert?("project_category_id"), do: true
  defp convert?("project_github_repo_id"), do: true
  defp convert?("project_skill_id"), do: true
  defp convert?("project_user_id"), do: true
  defp convert?("role_id"), do: true
  defp convert?("role_skill_id"), do: true
  defp convert?("skill_id"), do: true
  defp convert?("slugged_route_id"), do: true
  defp convert?("stripe_connect_account_id"), do: true
  defp convert?("stripe_connect_card_id"), do: true
  defp convert?("stripe_connect_charge_id"), do: true
  defp convert?("stripe_connect_customer_id"), do: true
  defp convert?("stripe_connect_plan_id"), do: true
  defp convert?("stripe_connect_subscription_id"), do: true
  defp convert?("stripe_event_id"), do: true
  defp convert?("stripe_external_account_id"), do: true
  defp convert?("stripe_file_upload_id"), do: true
  defp convert?("stripe_invoice_id"), do: true
  defp convert?("stripe_platform_card_id"), do: true
  defp convert?("stripe_platform_customer_id"), do: true
  defp convert?("task_id"), do: true
  defp convert?("task_list_id"), do: true
  defp convert?("task_skill_id"), do: true
  defp convert?("user_id"), do: true
  defp convert?("user_category_id"), do: true
  defp convert?("user_role_id"), do: true
  defp convert?("user_skill_id"), do: true
  defp convert?("user_task_id"), do: true
  defp convert?(_other), do: false

  defp ensure_integer(value) when is_binary(value), do: value |> String.parse
  defp ensure_integer(value), do: value
end
