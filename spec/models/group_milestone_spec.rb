require 'spec_helper'

describe GroupMilestone do
  let(:group) { build_stubbed(:group) }
  let(:project) { build_stubbed(:project, group: group) }
  let(:project_milestone) do
    build_stubbed(:milestone, title: "Milestone v1.2", project: project)
  end

  describe '.build' do
    it 'returns milestone with group assigned' do
      milestone = described_class.build(
        group,
        [project],
        project_milestone.title
      )

      expect(milestone.group).to eq group
    end
  end

  describe '.build_collection' do
    before do
      project_milestone
    end

    it 'returns array of milestones, each with group assigned' do
      milestones = described_class.build_collection(group, [project], {})
      expect(milestones).to all(have_attributes(group: group))
    end
  end
end
