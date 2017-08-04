require 'spec_helper'

describe 'CycleAnalytics#review' do
  extend CycleAnalyticsHelpers::TestGeneration

  let(:project) { build_stubbed(:project, :repository) }
  let(:from_date) { 10.days.ago }
  let(:user) { build_stubbed(:user, :admin) }
  subject { CycleAnalytics.new(project, from: from_date) }

  generate_cycle_analytics_spec(
    phase: :review,
    data_fn: -> (context) { { issue: context.build_stubbed(:issue, project: context.project) } },
    start_time_conditions: [["merge request that closes issue is created",
                             -> (context, data) do
                               context.create_merge_request_closing_issue(data[:issue])
                             end]],
    end_time_conditions:   [["merge request that closes issue is merged",
                             -> (context, data) do
                               context.merge_merge_requests_closing_issue(data[:issue])
                             end]],
    post_fn: nil)

  context "when a regular merge request (that doesn't close the issue) is created and merged" do
    it "returns nil" do
      MergeRequests::MergeService.new(project, user).execute(build_stubbed(:merge_request))

      expect(subject[:review].median).to be_nil
    end
  end
end
