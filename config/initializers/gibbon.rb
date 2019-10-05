# frozen_string_literal: true

Gibbon::Export.new(ENV['MAILCHIMP_API_KEY'])
Gibbon::Export.timeout = 15
Gibbon::Export.throws_exceptions = false
