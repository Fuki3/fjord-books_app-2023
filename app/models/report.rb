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

  after_create :save_new_mentions
  after_update :update_mentions
  after_destroy :delete_mentions

  def editable?(target_user)
    user == target_user
  end

  def mentioned_reports_id(text)
    text.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
  end

  def created_on
    created_at.to_date
  end

  def mention(other_report_id)
    active_relationships.new(mentioned_id: other_report_id).save!
  end

  def unmention(other_report_id)
    active_relationships.find_by(mentioned_id: other_report_id).destroy!
  end

  def save_new_mentions
    other_reports_id = mentioned_reports_id(content)
    other_reports_id.uniq.each { |id| mention(id) }
  end

  def update_mentions
    mentioning_reports.pluck(:id).each { |id| unmention(id) }
    mentioned_reports_id(content).uniq.each { |id| mention(id) }
  end

  def delete_mentions
    mentioning_reports.each { |id| unmention(id) }
    mentioned_reports.each { |report| report.unmention(self.id) }
  end
end
