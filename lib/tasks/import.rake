require 'csv'

namespace :data do
  desc "Import CSV file from ITIS"
  task csv: :environment do
  HttpImport.new(ENV['CSV_URL']).run
  end
end

class HttpImport
  attr_reader :uri, :request, :source
  def initialize(url)
    @uri     = URI(url)
    @request = Net::HTTP::Get.new uri
    @source  = CropDataSource.find_or_create_by(source_name: "ITIS")
  end

  def run
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request do |response|
        response.read_body{|r| parse(r)}
      end
    end
    puts 'Done'
  end

  def parse(response)
    rows = response.split("\n").map(&:parse_csv).select{|r| r.length == 5}
    rows.map{|r| handle_row(r) }
  end

  def handle_row(row)
    return if row[0] == 'tsn'
    crop = Crop.find_or_create_by(name: row[-1],
                                  binomial_name: row[1, 2].join(' '),
                                  common_names: Array(row[-1]),
                                  crop_data_source: source)
    print '.'
  rescue => e
    puts "Failure on #{row[0]}: #{e.message}"
  end
end