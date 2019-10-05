# frozen_string_literal: true

require 'csv'
namespace :import_crops do
  desc 'import crops from the csv file provided'
  task from_csv: :environment do
    crops = CSV.read("#{Rails.root}/lib/crops.csv")
    # remove nil or empty names, get unique names then save the crop
    crops.reject { |crop| crop[0].nil? || crop[0].blank? }.uniq { |crop| crop[0].downcase }.each do |crop|
      save_crop(crop)
    end
  end

  def save_crop(crop)
    binomial_name = crop[0]
    common_name = crop[1] ? crop[1] : binomial_name
    return if Crop.where(binomial_name: binomial_name).exists?
    Crop.create!(name: common_name, binomial_name: binomial_name)
    print '.'
  end
end
