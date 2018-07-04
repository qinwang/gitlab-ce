module Types
  class MutationType < BaseObject
    graphql_name "Mutation"

    field :toggle_wip, mutation: Mutations::MergeRequests::WipMutation
  end
end
