require 'csv'  


namespace :data_imports do
  desc "Import CSV file from ITIS"
  task :import_csv => :environment do
    file = ENV['data_file']
    CSV.foreach(file, headers: true) do |row|
      c = row.to_hash
      genus = c.fetch('unit_name1', '')
      species = c.fetch('unit_name2', '')
      sub_species = c.fetch('unit_name3', '')
      sub_species.gsub!('<null>', '')
      binomial_name = genus + ' ' + species + ' ' + sub_species
      name = c['vernacular_name']
      tsn = c['tsn']
      crop = Crop.create!(
        binomial_name: binomial_name,
        name: name
        )
      crop.crop_data_sources.create!(
        source_name: "tsn",
        reference: tsn
        )

    end
  end
end
