class MonetizationFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value.present? && %w(free paid grossing).include?(value.downcase)
      object.errors[attribute] <<
        'is not a valid monetization value.'\
        ' Please use: free, paid, or grossing.'
    end
  end
end
