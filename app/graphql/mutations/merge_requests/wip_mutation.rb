module Mutations
  module MergeRequests
    class WipMutation < Base
      def resolve(project_path:, iid:)
        merge_request = resolve_merge_request(project_path: project_path, iid: iid)
        project = merge_request.project

        ::MergeRequests::UpdateService.new(project, current_user, wip_event: toggle_wip_event(merge_request))
          .execute(merge_request)

        { merge_request: merge_request }
      end

      private

      def toggle_wip_event(merge_request)
        MergeRequest.work_in_progress?(merge_request.title) ? 'unwip' : 'wip'
      end
    end
  end
end
