class AddIndexCiJobArtifactsOnFileLocation < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  # This partial index is to be removed after the clean-up phase of the background migrations for legacy artifacts.
  TMP_PARTIAL_INDEX = 'tmp_index_ci_job_artifacts_on_id_with_null_file_location'.freeze

  def up
    add_concurrent_index(:ci_job_artifacts, :id, where: 'file_location is NULL', name: TMP_PARTIAL_INDEX)
  end

  def down
    remove_concurrent_index_by_name(:ci_job_artifacts, TMP_PARTIAL_INDEX)
  end
end

