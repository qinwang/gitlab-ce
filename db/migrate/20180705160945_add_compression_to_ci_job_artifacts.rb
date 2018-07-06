# rubocop:disable all
class AddCompressionToCiJobArtifacts < ActiveRecord::Migration
  def change
    add_column :ci_job_artifacts, :compression, :integer, limit: 2
  end
end
