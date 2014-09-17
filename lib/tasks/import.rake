require 'csv'  


namespace :data_imports do
  desc "Import CSV file from ITIS"
  task :import_csv => :environment do
    file = ENV['data_file']
    puts file
    csv_text = File.read(file)
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      c = row.to_hash
      genus = c.fetch('unit_name1', '')
      species = c.fetch('unit_name2', '')
      sub_species = c.fetch('unit_name3', '')
      sub_species.gsub!('<null>', '')
      binomial_name = genus + ' ' + species + ' ' + sub_species
      name = c['vernacular_name']
      tsn = c['tsn']
      Crop.create!(
        binomial_name: binomial_name,
        name: name,
        data_sources: {
          tsn: tsn
          })
      # Moulding.create!(row.to_hash)
    end
  end
end
