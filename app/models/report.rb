# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'mentioning_id', inverse_of: :mentioning, dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'mentioned_id', inverse_of: :mentioned, dependent: :destroy
  has_many :mentioning_reports, through: :active_relationships, source: :mentioned
  has_many :mentioned_reports, through: :passive_relationships, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  after_create :save_mentions
  after_update :delete_mentions, :save_mentions

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def save_mentions
    mentioned_report_ids = content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
    mentioned_report_ids.uniq.each { |id| active_relationships.new(mentioned_id: id).save! }
  end

  def delete_mentions
    active_relationships.destroy_all
  end
end
