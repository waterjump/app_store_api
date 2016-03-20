module Api
  class ReportsController < ApplicationController
    respond_to :json

    def show
      @results = { "hello" => "world" }
      render json: @results
    end
  end
end

