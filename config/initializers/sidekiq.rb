Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://stark-crag-12943.herokuapp.com' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://stark-crag-12943.herokuapp.com' }
end 