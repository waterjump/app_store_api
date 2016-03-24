module Validate
  class Base < ApplicationController
    include ActiveModel::Validations

    attr_accessor :category_id, :monetization

    validates :category_id, presence: true, numericality: true
    validates :monetization, presence: true

    def initialize(params={})
      @category_id = params[:category_id]
      @monetization = params[:monetization]
      @rank = params[:rank]
      ActionController::Parameters.new(params).permit(
        :category_id,
        :monetization,
        :format,
        :id,
        :rank)
    end
  end
end
