CivicInformation.configure do |config|
  config.google_api_key = Rails.application.credentials.google[:api_key]
end