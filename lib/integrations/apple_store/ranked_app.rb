class AppleStore::RankedApp
  include AppleStore::Concerns::Gateway

  attr_reader :metadata

  def initialize(adam_id)
    @adam_id = adam_id
    @endpoint = "https://itunes.apple.com/lookup?id=#{adam_id}"
  end

  def metadata
    @metadata ||=
      Rails.cache.fetch("ranked_app-adam_id_#{@adam_id}", expires_in: 30.days) do
        data = gateway.perform_api_call(@endpoint)
        metadata_hash(data)
      end
  end

  private

  def metadata_hash(data)
    json = JSON.parse(data).with_indifferent_access
    return {} unless json[:resultCount] > 0
    app = json[:results].first

    {
      id:                   @adam_id,
      name:                 app[:trackName],
      description:          app[:description],
      small_icon_url:       app[:artworkUrl60],
      publisher_name:       app[:sellerName],
      price:                app[:price],
      version:              app[:version],
      average_user_rating:  app[:averageUserRating]
    }
  end
end
