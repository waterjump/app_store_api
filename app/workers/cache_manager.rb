class CacheManager
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Rails.logger.info 'CacheManager kicking off.'
    category_ranges.each do |range|
      if range.is_a?(Range)
        range.each do |cat_id|
          run_report(cat_id)
        end
      elsif range.is_a?(Integer)
        run_report(range)
      end
    end
  end

  private

  def category_ranges
    [
      36,
      6000..6022,
      7001..7019,
      13_001..13_030
    ]
  end

  def monetizations
    %w(free paid grossing)
  end

  def run_report(cat)
    monetizations.each do |mon|
      Fetcher.perform_async(cat, mon)
    end
  end
end
