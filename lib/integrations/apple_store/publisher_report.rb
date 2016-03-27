module AppleStore
  class PublisherReport

    def initialize(params)
      @category_id = params['category_id']
      @monetization = params['monetization']
      @results = {}
    end

    def perform
      apps_report = Report.new(
                      category_id: @category_id,
                      monetization: @monetization
                    ).perform

      aggregate_publishers(JSON.parse(apps_report))

      sort_results

      format_results
    end

    private

    def aggregate_publishers(apps_report)
        apps_report.each do |app|
        id = app['publisher_id']
        if @results[id].present?
          @results[id][:number_of_apps] += 1
          @results[id][:app_names] << app['name']
        else
          @results.merge!(
            id => {
              publisher_id: id,
              publisher_name: app['publisher_name'],
              number_of_apps: 1,
              app_names: [app['name']]
            }
          )
        end
      end
    end

    def sort_results
      @results = @results
        .sort_by { |k, v| v[:number_of_apps] }
        .reverse
    end

    def format_results
      index = 1
      results = []
      @results.each do |id, publisher|
        publisher.merge!(rank: index)
        results << publisher
        index += 1
      end

      results.to_json
    end
  end
end
