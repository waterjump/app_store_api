module Api
  class AppsController < ApplicationController
    respond_to :json
    before_action :validate_params

    def index
      if params['rank'].present?
        # give single app
      else
        @apps = AppleStore::Report.new(params).perform
        respond_to do |format|
          format.json { render json: @apps }
        end
      end
    end
  end
end

