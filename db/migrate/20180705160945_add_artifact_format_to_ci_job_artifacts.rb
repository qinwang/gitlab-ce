# rubocop:disable all
class AddArtifactFormatToCiJobArtifacts < ActiveRecord::Migration
  def change
    add_column :ci_job_artifacts, :artifact_format, :integer, limit: 2
  end
end
