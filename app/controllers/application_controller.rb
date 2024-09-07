# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
