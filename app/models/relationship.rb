# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :mentioning, class_name: 'Report'
  belongs_to :mentioned, class_name: 'Report'

  validates :mentioning_id, presence: true
  validates :mentioned_id, presence: true
  validates :mentioning_id, uniqueness: { scope: :mentioned_id }
end
