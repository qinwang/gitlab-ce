require 'spec_helper'

describe DeployKey, :mailer do
  describe "Associations" do
    it { is_expected.to have_many(:deploy_keys_projects) }
    it { is_expected.to have_many(:projects) }
  end

  describe 'notification' do
    let(:user) { build_stubbed(:user) }

    it 'does not send a notification' do
      perform_enqueued_jobs do
        build_stubbed(:deploy_key, user: user)
      end

      should_not_email(user)
    end
  end
end
