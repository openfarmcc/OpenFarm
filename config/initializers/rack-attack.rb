class Rack::Attack
  ### Throttle Spammy Clients ###
  # Throttle all requests by IP (60rpm)
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  ### Prevent Brute-Force Login Attacks ###
  # Throttle requests to /sign_in by IP address
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path.include?('/sign_in') && req.post?
      req.ip
    end
  end
end