class FillFileLocationToJobArtifacts < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  MIGRATION = 'MigrateLegacyArtifacts'.freeze
  BATCH_SIZE = 10_000

  disable_ddl_transaction!

  CI_JOB_ARTIFACT_FILE_LOCATION_HASHED_PATH = 2 # Equavalant to Ci::JobArtifact.file_locations[:hashed_path]

  class JobArtifact < ActiveRecord::Base
    include EachBatch
    self.table_name = 'ci_job_artifacts'

    def self.params_for_background_migration
      yield self.where(file_store: nil), 'FillFileStoreJobArtifact', 5.minutes, BATCH_SIZE
    end
  end

  def up
    FillFileLocationToJobArtifacts::JobArtifact.where(file_location: nil).each_batch(of: BATCH_SIZE) do |relation|
      relation.update_all(file_location: CI_JOB_ARTIFACT_FILE_LOCATION_HASHED_PATH)
    end
  end

  def down
    # no-op
  end
end
