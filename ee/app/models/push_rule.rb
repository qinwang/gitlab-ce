class PushRule < ActiveRecord::Base
  belongs_to :project

  validates :project, presence: true, unless: "is_sample?"
  validates :max_file_size, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  FILES_BLACKLIST = YAML.load_file(Rails.root.join('lib/gitlab/checks/files_blacklist.yml'))
  SETTINGS_WITH_GLOBAL_DEFAULT = %i[
    reject_unsigned_commits
    commit_committer_check
  ].freeze

  def self.global
    find_by(is_sample: true)
  end

  def commit_validation?
    commit_message_regex.present? ||
      branch_name_regex.present? ||
      author_email_regex.present? ||
      reject_unsigned_commits ||
      commit_committer_check ||
      member_check ||
      file_name_regex.present? ||
      max_file_size > 0 ||
      prevent_secrets
  end

  def commit_signature_allowed?(commit)
    return true unless available?(:reject_unsigned_commits)
    return true unless reject_unsigned_commits

    commit.has_signature?
  end

  def committer_allowed?(committer_email, current_user)
    return true unless available?(:commit_committer_check)
    return true unless commit_committer_check

    current_user.verified_email?(committer_email)
  end

  def commit_message_allowed?(message)
    data_match?(message, commit_message_regex)
  end

  def branch_name_allowed?(branch)
    data_match?(branch, branch_name_regex)
  end

  def author_email_allowed?(email)
    data_match?(email, author_email_regex)
  end

  def filename_blacklisted?(file_path)
    regex_list = []
    regex_list.concat(FILES_BLACKLIST) if prevent_secrets
    regex_list << file_name_regex if file_name_regex

    regex_list.find { |regex| data_match?(file_path, regex) }
  end

  def global?
    is_sample?
  end

  def available?(feature_sym)
    if global?
      License.feature_available?(feature_sym)
    else
      project&.feature_available?(feature_sym)
    end
  end

  def reject_unsigned_commits
    read_setting_with_global_default(:reject_unsigned_commits)
  end
  alias_method :reject_unsigned_commits?, :reject_unsigned_commits

  def reject_unsigned_commits=(value)
    write_setting_with_global_default(:reject_unsigned_commits, value)
  end

  def commit_committer_check
    read_setting_with_global_default(:commit_committer_check)
  end
  alias_method :commit_committer_check?, :commit_committer_check

  def commit_committer_check=(value)
    write_setting_with_global_default(:commit_committer_check, value)
  end

  private

  def data_match?(data, regex)
    if regex.present?
      !!(data =~ Regexp.new(regex))
    else
      true
    end
  end

  def read_setting_with_global_default(setting)
    value = read_attribute(setting)

    # return if value is true/false or if current object is the global setting
    return value if global? || !value.nil?

    PushRule.global&.public_send(setting)
  end

  def write_setting_with_global_default(setting, value)
    enabled_globally = PushRule.global&.public_send(setting)
    is_disabled = !Gitlab::Utils.to_boolean(value)

    # If setting is globally disabled and user disable it at project level,
    # reset the attr so we can use the default global if required later.
    if !enabled_globally && is_disabled
      write_attribute(setting, nil)
    else
      write_attribute(setting, value)
    end
  end
end