require 'spec_helper'

describe Editable do
  describe '#edited?' do
    let(:issue) { build_stubbed(:issue, last_edited_at: nil) }
    let(:edited_issue) { build_stubbed(:issue, created_at: 3.days.ago, last_edited_at: 2.days.ago) }

    it { expect(issue.edited?).to eq(false) }
    it { expect(edited_issue.edited?).to eq(true) }
  end
end
