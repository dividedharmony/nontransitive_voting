# frozen_string_literal: true

class Rack::Attack
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip  unless req.path.start_with?('/assets')
  end

  throttle('signin/ip', :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/sign_in' && req.post?
      req.ip
    end
  end

  throttle("logins/email", :limit => 5, :period => 20.seconds) do |req|
    if req.path == '/login' && req.post?
      # return the email if present, nil otherwise
      req.params['email'].presence
    end
  end
end
