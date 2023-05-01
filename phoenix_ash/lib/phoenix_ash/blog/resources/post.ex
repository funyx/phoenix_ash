defmodule PhoenixAsh.Blog.Post do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("post")
    repo(PhoenixAsh.Repo)
  end

  code_interface do
    define_for(PhoenixAsh.Blog)
    define(:create, action: :create)
    define(:read_all, action: :read)
    define(:update, action: :update)
    define(:destroy, action: :destroy)
    define(:get_by_id, args: [:id], action: :by_id)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    read :by_id do
      argument(:id, :uuid, allow_nil?: false)
      get?(true)
      filter(expr(id == ^arg(:id)))
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :title, :string do
      allow_nil?(false)
    end

    attribute(:content, :string)
  end
end
