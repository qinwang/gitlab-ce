class AddFileLocationToCiJobArtifacts < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    # `default: 2` is equivalant to Ci::JobArtifact.file_locations[:hashed_path]
    add_column_with_default :ci_job_artifacts, :file_location, :integer, limit: 2, default: 2, allow_null: false
  end

  def down
    remove_column :ci_job_artifacts, :file_location
  end
end
