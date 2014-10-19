Rails.backtrace_cleaner.add_silencer do |line|
  line =~ "/gems/"
end
