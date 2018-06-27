class MigrateLegacyArtifactsToJobArtifacts < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  MIGRATION = 'MigrateLegacyArtifacts'.freeze
  BATCH_SIZE = 2000
  TMP_INDEX = 'tmp_index_ci_builds_on_present_artifacts_file'.freeze

  disable_ddl_transaction!

  class Build < ActiveRecord::Base
    include EachBatch

    self.table_name = 'ci_builds'
    self.inheritance_column = :_type_disabled

    scope :with_legacy_artifacts, -> { where("artifacts_file <> ''") }
  end

  def up
    MigrateLegacyArtifactsToJobArtifacts::Build
      .with_legacy_artifacts.tap do |relation|
      queue_background_migration_jobs_by_range_at_intervals(relation,
                                                            MIGRATION,
                                                            5.minutes,
                                                            batch_size: BATCH_SIZE)
    end
  end

  def down
    # no-op
  end
end
