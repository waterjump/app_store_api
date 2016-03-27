class CategoryIdFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    code = value.to_i
    unless code == 36 || code_in_valid_ranges?(code)
      object.errors[attribute] <<
        ['is not a valid app store category_id.',
        '(Try 36, 6000-6022, 7001-7019, 13001-13030)'].join(' ')
    end
  end

  def code_in_valid_ranges?(code)
    valid_ranges.inject(false) do |memo, range|
      memo = memo || code.between?(range[0], range[1])
    end
  end

  def valid_ranges
    [
      [6000, 6022],
      [7001, 7019],
      [13001, 13030]
    ]
  end
end
