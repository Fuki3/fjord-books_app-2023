# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = users(:alice)
    report = reports(:one)
    assert report.editable?(user)
  end

  test '#created_on' do
    travel_to Time.zone.local(2025, 9, 5, 10, 0, 0) do
      report = Report.create!(user: users(:alice), title: 'MyString', content: 'MyText')
      assert_equal Time.zone.local(2025, 9, 5, 10, 0, 0).to_date, report.created_on
    end
  end

  test '#save_mentions' do
    report = reports(:one)
    other_report = Report.create!(user: users(:alice), title: 'MyString', content: '参考になりました！')
    assert_not_includes other_report.mentioning_reports, report
    other_report.update!(content: "http://localhost:3000/reports/#{report.id}とhttp://localhost:3000/reports/#{other_report.id}が参考になりました！")
    assert_includes other_report.mentioning_reports, report
    assert_not_includes other_report.mentioning_reports, other_report
    other_report.update!(content: "aliceさんのhttp://localhost:3000/reports/#{report.id}の日報は参考になります！")
    assert_includes other_report.mentioning_reports.reload, report
    other_report.update!(content: 'aliceさんの日報は参考になります！')
    assert_not_includes other_report.mentioning_reports.reload, report
  end
end
