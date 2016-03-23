module Api
  class ReportsController < ApplicationController
    respond_to :json

    def show
      if validate_params
        @results = AppleStore::Report.new(params).perform
        render json: @results
      else
        render :json => {:error => 'Bad Request'}.to_json, :status => 400
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

