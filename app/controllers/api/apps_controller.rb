module Api
  class AppsController < ApplicationController
    respond_to :json
    before_action :validate_params

    def index
      @apps = AppleStore::Report.new(params).perform
      respond_to do |format|
        format.json { render json: @apps }
      end
    end
  end
end
