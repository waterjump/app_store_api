module Validate
  class Base < ApplicationController
    include ActiveModel::Validations

    attr_accessor :category_id, :monetization, :rank

    validates :category_id, presence: true, numericality: true
    validates :monetization, presence: true,  monetization_format: true
    validates :rank, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 200
    }, allow_nil: true, allow_blank: true

    def initialize(params = {})
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
