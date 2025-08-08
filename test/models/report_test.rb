# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = users(:alice)
    report = reports(:one)
    assert report.editable?(user)
  end

  test '#created_on' do
    report = reports(:one)
    assert_equal report.created_at.to_date, report.created_on
  end
end
