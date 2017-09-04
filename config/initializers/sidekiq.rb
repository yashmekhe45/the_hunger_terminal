Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'].presence || 'redis://localhost:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISCLOUD_URL'].presence || 'redis://localhost:6379' }
end
