class AddIndexToCiBuildsArtifactsFile < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  # This partial index is to be removed after the clean-up phase of the background migrations for legacy artifacts.
  TMP_PARTIAL_INDEX = 'tmp_partial_index_ci_builds_on_id_with_legacy_artifacts'.freeze

  def up
    return unless Gitlab::Database.postgresql?

    add_concurrent_index(:ci_builds, :id, where: "artifacts_file <> ''", name: TMP_PARTIAL_INDEX)
  end

  def down
    return unless Gitlab::Database.postgresql?

    remove_concurrent_index_by_name(:ci_builds, TMP_PARTIAL_INDEX)
  end
end
