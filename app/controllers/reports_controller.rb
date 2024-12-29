# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports
  def index
    @reports = Report.all
  end

  # GET /reports/1
  def show
    @comment = Comment.new
    @comments = @report.comments
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  def create
    @report = current_user.reports.build(report_params)
      if @report.save
        redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: t('activerecord.models.reports'))
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /reports/1
  def update
    return if current_user.id != @report.user_id
      if @report.update(report_params)
        redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: t('activerecord.models.reports'))
      else
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /reports/1
  def destroy
    return if current_user.id != @report.user_id
    @report.destroy
    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: t('activerecord.models.reports'))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :memo)
  end
end
