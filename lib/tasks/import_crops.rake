# frozen_string_literal: true
require 'csv'
namespace :import_crops do
  desc 'import crops from the csv file provided'
  task from_csv: :environment do
    crops = CSV.read("#{Rails.root}/lib/crops.csv")
    # remove nil or empty names, get unique names then save the crop
    crops.reject { |crop| crop[0].nil? || crop[0].empty? }
         .uniq { |crop| crop[0].downcase }
         .each { |crop| save_crop(crop) }
  end

  def save_crop(crop)
    return if Crop.where(binomial_name: crop.first).exists?
    Crop.create!(name: crop[0], binomial_name: crop[0], description: crop[1])
    print '.'
  end
end
