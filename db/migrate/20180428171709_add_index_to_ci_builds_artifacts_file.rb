class AddIndexToCiBuildsArtifactsFile < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    return unless Gitlab::Database.postgresql?

    add_concurrent_index :ci_builds, :id, where: "artifacts_file <> ''"
  end

  def down
    return unless Gitlab::Database.postgresql?

    remove_concurrent_index :ci_builds, :id, where: "artifacts_file <> ''"
  end
end
