defmodule CodeCorps.Web.StripeConnectPlanPolicy do
  import CodeCorps.Web.Helpers.Policy,
    only: [get_project: 1, owned_by?: 2]

  alias CodeCorps.{StripeConnectPlan, User}

  def show?(%User{} = user, %StripeConnectPlan{} = plan),
    do: plan |> get_project |> owned_by?(user)
  def create?(%User{} = user, %Ecto.Changeset{} = changeset),
    do: changeset |> get_project |> owned_by?(user)
end