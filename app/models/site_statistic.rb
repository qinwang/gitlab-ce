class SiteStatistic < ActiveRecord::Base
  # prevents the creation of multiple rows
  default_value_for :id, 1

  COUNTER_ATTRIBUTES = %w(repositories_count wikis_count).freeze

  def self.track(raw_attribute)
    raise ArgumentError, 'Invalid attribute to track' unless raw_attribute.in?(COUNTER_ATTRIBUTES)

    with_statistics_available do
      attribute = self.connection.quote_column_name(raw_attribute)

      SiteStatistic.update_all(["#{attribute} = #{attribute}+1"])
    end
  end

  def self.untrack(raw_attribute)
    raise ArgumentError, 'Invalid attribute to untrack' unless raw_attribute.in?(COUNTER_ATTRIBUTES)

    with_statistics_available do
      attribute = self.connection.quote_column_name(raw_attribute)

      SiteStatistic.update_all(["#{attribute} = #{attribute}-1 WHERE #{attribute} > 0"])
    end
  end

  def self.with_statistics_available
    # we have quite a lot of specs testing migrations, we need this and the rescue to not break them
    SiteStatistic.transaction(requires_new: true) do
      SiteStatistic.first_or_create

      yield
    end
  rescue ActiveRecord::StatementInvalid
    true
  end

  def self.fetch
    SiteStatistic.first_or_create!
  end
end
