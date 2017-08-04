require 'spec_helper'

describe 'CycleAnalytics#issue' do
  extend CycleAnalyticsHelpers::TestGeneration

  let(:project) { build_stubbed(:project, :repository) }
  let(:from_date) { 10.days.ago }
  let(:user) { build_stubbed(:user, :admin) }
  subject { CycleAnalytics.new(project, from: from_date) }

  generate_cycle_analytics_spec(
    phase: :issue,
    data_fn: -> (context) { { issue: context.build(:issue, project: context.project) } },
    start_time_conditions: [["issue created", -> (context, data) { data[:issue].save }]],
    end_time_conditions:   [["issue associated with a milestone",
                             -> (context, data) do
                               if data[:issue].persisted?
                                 data[:issue].update(milestone: context.build_stubbed(:milestone, project: context.project))
                               end
                             end],
                            ["list label added to issue",
                             -> (context, data) do
                               if data[:issue].persisted?
                                 data[:issue].update(label_ids: [context.build_stubbed(:label, lists: [context.build_stubbed(:list)]).id])
                               end
                             end]],
    post_fn: -> (context, data) do
      if data[:issue].persisted?
        context.create_merge_request_closing_issue(data[:issue].reload)
        context.merge_merge_requests_closing_issue(data[:issue])
      end
    end)

  context "when a regular label (instead of a list label) is added to the issue" do
    it "returns nil" do
      regular_label = build_stubbed(:label)
      issue = build_stubbed(:issue, project: project)
      issue.update(label_ids: [regular_label.id])

      create_merge_request_closing_issue(issue)
      merge_merge_requests_closing_issue(issue)

      expect(subject[:issue].median).to be_nil
    end
  end
end
