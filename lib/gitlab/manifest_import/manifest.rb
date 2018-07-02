# Class to parse manifest file to import multiple projects at once
#
# <manifest>
#   <remote review="https://android-review.googlesource.com/" />
#   <project path="platform-common" name="platform" />
#   <project path="platform/art" name="platform/art" />
#   <project path="platform/device" name="platform/device" />
# </manifest>
#
# 1. Project path must be uniq and can't be part of other project path.
#    For example, you can't have projects with 'foo' and 'foo/bar' paths.
# 2. Remote must be present with review attribute so GitLab knows
#    where to fetch source code
# 3. For each nested keyword in path a corresponding group will be created.
#    For example if a path is 'foo/bar' then GitLab will create a group 'foo'
#    and a project 'bar' in it.
module Gitlab
  module ManifestImport
    class Manifest
      attr_reader :parsed_xml, :errors

      def initialize(file)
        @parsed_xml = File.open(file) { |f| Nokogiri::XML(f) }
        @errors = []
      end

      def projects
        raw_projects.each_with_index.map do |project, i|
          {
            id: i,
            name: project['name'],
            path: project['path'],
            url: repository_url(project['name'])
          }
        end
      end

      def valid?
        unless validate_remote
          @errors << 'Make sure a <remote> tag is present and is valid.'
        end

        unless validate_projects
          @errors << 'Make sure every <project> tag has name and path attributes.'
        end

        @errors.empty?
      end

      private

      def validate_remote
        remote.present? && URI.parse(remote).host
      rescue URI::Error
        false
      end

      def validate_projects
        raw_projects.all? do |project|
          project['name'] && project['path']
        end
      end

      def repository_url(name)
        URI.join(remote, name).to_s
      end

      def remote
        @remote ||= parsed_xml.css('manifest > remote').first['review']
      end

      def raw_projects
        @raw_projects ||= parsed_xml.css('manifest > project')
      end
    end
  end
end
