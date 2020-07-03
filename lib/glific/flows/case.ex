defmodule Glific.Flows.Case do
  @moduledoc """
  The Case object which encapsulates one category in a given node.
  """
  alias __MODULE__

  use Glific.Schema
  import Ecto.Changeset

  alias Glific.Enums.FlowCase

  alias Glific.Flows.{
    Category,
    Router
  }

  @required_fields [:type, :arguments, :category_uuid, :router_uuid]
  @optional_fields []

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          uuid: Ecto.UUID.t() | nil,
          type: FlowCase | nil,
          arguments: [String.t()],
          category_uuid: Ecto.UUID.t() | nil,
          category: Category.t() | Ecto.Association.NotLoaded.t() | nil,
          router_uuid: Ecto.UUID.t() | nil,
          router: Router.t() | Ecto.Association.NotLoaded.t() | nil
        }

  schema "cases" do
    field :name, :string

    field :type, FlowCase
    field :arguments, {:array, :string}, default: []

    belongs_to :router, Router, foreign_key: :router_uuid, references: :uuid, primary_key: true

    belongs_to :category, Category,
      foreign_key: :category_uuid,
      references: :uuid,
      primary_key: true
  end

  @doc """
  Standard changeset pattern we use for all data types
  """
  @spec changeset(Case.t(), map()) :: Ecto.Changeset.t()
  def changeset(case, attrs) do
    case
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:router_uuid)
    |> foreign_key_constraint(:category_uuid)
  end
end
