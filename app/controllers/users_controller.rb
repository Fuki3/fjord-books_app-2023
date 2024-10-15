# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(1).order(:id)
  end

  def show
    @user = User.find(params[:id])
  end
end
