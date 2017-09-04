Devise::Async.backend = :sidekiq
Devise::Async.enabled = !Rails.env.test?
Devise::Async.queue = :mailers