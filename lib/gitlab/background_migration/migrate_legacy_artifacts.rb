# frozen_string_literal: true
# rubocop:disable Metrics/AbcSize
# rubocop:disable Style/Documentation

module Gitlab
  module BackgroundMigration
    class MigrateLegacyArtifacts
      FILE_LOCAL_STORE = 1 # equal to ObjectStorage::Store::LOCAL
      ARCHIVE_FILE_TYPE = 1 # equal to Ci::JobArtifact.file_types['archive']
      METADATA_FILE_TYPE = 2 # equal to Ci::JobArtifact.file_types['metadata']
      LEGACY_PATH_FILE_LOCATION = 1 # equal to Ci::JobArtifact.file_location['legacy_path']

      def perform(start_id, stop_id)
        ActiveRecord::Base.transaction do
          insert_archives(start_id, stop_id)
          insert_metadatas(start_id, stop_id)
          delete_legacy_artifacts(start_id, stop_id)
        end
      end

      private

      def insert_archives(start_id, stop_id)
        ActiveRecord::Base.connection.execute <<~SQL
          INSERT INTO ci_job_artifacts (
                project_id,
                job_id,
                expire_at,
                file_location,
                created_at,
                updated_at,
                file,
                size,
                file_store,
                file_type)
          SELECT project_id,
                id,
                artifacts_expire_at,
                #{LEGACY_PATH_FILE_LOCATION},
                created_at,
                created_at,
                artifacts_file,
                artifacts_size,
                COALESCE(artifacts_file_store, #{FILE_LOCAL_STORE}),
                #{ARCHIVE_FILE_TYPE}
            FROM ci_builds
          WHERE id BETWEEN #{start_id.to_i} AND #{stop_id.to_i}
                  AND artifacts_file <> ''
                  AND NOT EXISTS (
                    SELECT 1 FROM ci_job_artifacts
                    WHERE (ci_builds.id = ci_job_artifacts.job_id)
                      AND ci_job_artifacts.file_type = #{ARCHIVE_FILE_TYPE})
        SQL
      end

      def insert_metadatas(start_id, stop_id)
        ActiveRecord::Base.connection.execute <<~SQL
          INSERT INTO ci_job_artifacts (
                project_id,
                job_id,
                expire_at,
                file_location,
                created_at,
                updated_at,
                file,
                size,
                file_store,
                file_type)
          SELECT project_id,
                id,
                artifacts_expire_at,
                #{LEGACY_PATH_FILE_LOCATION},
                created_at,
                created_at,
                artifacts_metadata,
                NULL,
                COALESCE(artifacts_metadata_store, #{FILE_LOCAL_STORE}),
                #{METADATA_FILE_TYPE}
            FROM ci_builds
          WHERE id BETWEEN #{start_id.to_i} AND #{stop_id.to_i}
                  AND artifacts_file <> '' AND artifacts_metadata <> ''
                  AND NOT EXISTS (
                    SELECT 1 FROM ci_job_artifacts
                    WHERE (ci_builds.id = ci_job_artifacts.job_id)
                      AND ci_job_artifacts.file_type = #{METADATA_FILE_TYPE})
        SQL
      end

      def delete_legacy_artifacts(start_id, stop_id)
        ActiveRecord::Base.connection.execute <<~SQL
          UPDATE ci_builds
             SET artifacts_file = NULL,
                 artifacts_file_store = NULL,
                 artifacts_size = NULL,
                 artifacts_metadata = NULL,
                 artifacts_metadata_store = NULL
           WHERE id BETWEEN #{start_id.to_i} AND #{stop_id.to_i}
                   AND artifacts_file <> ''
        SQL
      end
    end
  end
end
