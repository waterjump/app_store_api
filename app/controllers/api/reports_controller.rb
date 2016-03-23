module Api
  class ReportsController < ApplicationController
    respond_to :json

    def show
      if validate_params
        @apps = AppleStore::Report.new(params).perform
        respond_to do |format|
          format.json { render json: @apps }
        end
      else
        respond_to do |format|
          format.json { render json: {error: 'Bad Request'}.to_json, status: 400 }
        end
      end
    end

    private

    def validate_params
      required_parameters = [:category_id, :monetization]
      valid = required_parameters.reduce(true) do |memo, param|
        memo = memo && params.include?(param)
      end
      valid
    end
  end
end

