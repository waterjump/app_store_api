class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  def validate_params
    activity = Validate::Base.new(params)
    render json: { error: activity.errors }, status: 400 unless activity.valid?
  end

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render json: { error: { unknown_parameters: pme.params } },
           status: 400
  end
end
