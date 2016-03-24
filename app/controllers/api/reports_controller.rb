module Api
  class ReportsController < ApplicationController
    respond_to :json
    before_action :validate_params

    def show
      @apps = AppleStore::Report.new(params).perform
      respond_to do |format|
        format.json { render json: @apps }
      end
    end
  end
end

