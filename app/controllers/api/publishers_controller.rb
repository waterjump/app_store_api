module Api
  class PublishersController < ApplicationController
    before_action :validate_params

    def index
      @publishers = AppleStore::PublisherReport.new(params).perform
      respond_to do |format|
        format.json { render json: @publishers }
      end
    end
  end
end

