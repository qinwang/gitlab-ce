require 'spec_helper'

describe 'CycleAnalytics#plan' do
  extend CycleAnalyticsHelpers::TestGeneration

  let(:project) { build_stubbed(:project, :repository) }
  let(:from_date) { 10.days.ago }
  let(:user) { build_stubbed(:user, :admin) }
  subject { CycleAnalytics.new(project, from: from_date) }

  generate_cycle_analytics_spec(
    phase: :plan,
    data_fn: -> (context) do
      {
        issue: context.build_stubbed(:issue, project: context.project),
        branch_name: context.generate(:branch)
      }
    end,
    start_time_conditions: [["issue associated with a milestone",
                             -> (context, data) do
                               data[:issue].update(milestone: context.build_stubbed(:milestone, project: context.project))
                             end],
                            ["list label added to issue",
                             -> (context, data) do
                               data[:issue].update(label_ids: [context.build_stubbed(:label, lists: [context.build_stubbed(:list)]).id])
                             end]],
    end_time_conditions:   [["issue mentioned in a commit",
                             -> (context, data) do
                               context.create_commit_referencing_issue(data[:issue], branch_name: data[:branch_name])
                             end]],
    post_fn: -> (context, data) do
      context.create_merge_request_closing_issue(data[:issue], source_branch: data[:branch_name])
      context.merge_merge_requests_closing_issue(data[:issue])
    end)

  context "when a regular label (instead of a list label) is added to the issue" do
    it "returns nil" do
      branch_name = generate(:branch)
      label = build_stubbed(:label)
      issue = build_stubbed(:issue, project: project)
      issue.update(label_ids: [label.id])
      create_commit_referencing_issue(issue, branch_name: branch_name)

      create_merge_request_closing_issue(issue, source_branch: branch_name)
      merge_merge_requests_closing_issue(issue)

      expect(subject[:issue].median).to be_nil
    end
  end
end
