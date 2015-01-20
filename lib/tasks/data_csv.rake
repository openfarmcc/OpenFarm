require 'csv'

namespace :data do
  desc "Import CSV file from ITIS"
  task csv: :environment do
  CsvHttpImport.new(ENV['CSV_URL']).run
  end
end

class CsvHttpImport
  attr_reader :uri, :request, :source
  def initialize(url)
    @uri     = URI(url)
    @request = Net::HTTP::Get.new uri
    @source  = CropDataSource.find_or_create_by(source_name: "RORY")
  end

  def run
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request do |response|
        response.read_body { |r| parse(r) }
      end
    end
    puts 'Done'
  end

  def parse(response)
    seriously_dude?(response).map{|r| handle_row(r) }
  end

  # "CSV is one hell of a drug."
  #   -- Benjamin Franklin
  def seriously_dude?(response)
    response.split("\n").map do |row|
      begin
        row.parse_csv.map(&:downcase!).compact
      rescue
        nil
      end
    end.select{|r| r.present? && (r.length > 1)}.uniq
  end

  def handle_row(row)
    binomial_name = row[0]
    all_names     = row[1].split(',')
    common_name   = all_names.first
    crop = Crop.find_or_create_by(name: common_name,
                                  binomial_name: binomial_name,
                                  common_names: all_names,
                                  crop_data_source: source)
    print '.'
  rescue => e
    puts "Failure on #{row[0]}: #{e.message}"
  end
end
