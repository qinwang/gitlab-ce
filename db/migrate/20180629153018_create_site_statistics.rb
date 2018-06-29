class CreateSiteStatistics < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :site_statistics do |t|
      t.integer :repositories_count, default: 0, null: false
      t.integer :wikis_count, default: 0, null: false
    end
  end
end
