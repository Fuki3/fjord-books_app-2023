# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = users(:alice)
    report = reports(:one)
    assert report.editable?(user)
  end

  test '#created_on' do
    travel_to Time.zone.local(2025, 9, 5, 10, 0, 0)
    report = Report.create!(user: users(:alice), title: 'MyString', content: 'MyText')
    assert_equal Time.zone.local(2025, 9, 5, 10, 0, 0).to_date, report.created_on
    travel_back
  end
end
