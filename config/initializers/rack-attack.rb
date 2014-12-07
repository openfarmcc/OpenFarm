class Rack::Attack
  ### Throttle Spammy Clients ###
  # Throttle all requests by IP (60rpm)
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  ### Prevent Brute-Force Login Attacks ###
  # Throttle requests to /sign_in by IP address
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path.include?('/sign_in') && req.post?
  end
end

# Always allow requests from localhost
# (blacklist & throttles are skipped)
Rack::Attack.whitelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  '127.0.0.1' == req.ip
end
