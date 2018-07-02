class MigrateLegacyArtifactsToJobArtifacts < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  MIGRATION = 'MigrateLegacyArtifacts'.freeze
  BATCH_SIZE = 100
  TMP_INDEX = 'tmp_partial_index_ci_builds_on_id_with_legacy_artifacts'.freeze

  disable_ddl_transaction!

  class Build < ActiveRecord::Base
    include EachBatch

    self.table_name = 'ci_builds'
    self.inheritance_column = :_type_disabled

    scope :with_legacy_artifacts, -> { where("artifacts_file <> ''") }
  end

  def up
    unless index_exists_by_name?(:ci_builds, TMP_INDEX)
      add_concurrent_index(:ci_builds, :id, where: "artifacts_file <> ''", name: TMP_INDEX)
    end

    MigrateLegacyArtifactsToJobArtifacts::Build
      .with_legacy_artifacts.tap do |relation|
      queue_background_migration_jobs_by_range_at_intervals(relation,
                                                            MIGRATION,
                                                            5.minutes,
                                                            batch_size: BATCH_SIZE)
    end
  end

  def down
    if index_exists_by_name?(:ci_builds, TMP_INDEX)
      remove_concurrent_index_by_name(:ci_builds, TMP_INDEX)
    end
  end
end
