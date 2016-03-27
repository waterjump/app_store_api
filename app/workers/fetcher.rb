class Fetcher
  include Sidekiq::Worker

  def perform(category_id, monetization)
    report = AppleStore::PublisherReport.new(
        'category_id' => category_id,
        'monetization' => monetization)
    report.perform
    Rails.logger.info "Fetcher ran report for category_id: #{category_id}, monetization: #{monetization}"
  end
end
