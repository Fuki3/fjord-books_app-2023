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

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def delete_mentions
    active_relationships.destroy_all
  end

  private

  def mentioned_report_ids
    content.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
  end

  def mention(other_report_id)
    active_relationships.new(mentioned_id: other_report_id).save!
  end

  def unmention(other_report_id)
    active_relationships.find_by(mentioned_id: other_report_id).destroy!
  end

  def save_new_mentions
    other_report_ids = mentioned_report_ids
    other_report_ids.uniq.each { |id| mention(id) }
  end

  def update_mentions
    active_relationships.destroy_all
    mentioned_report_ids.uniq.each { |id| mention(id) }
  end
end
