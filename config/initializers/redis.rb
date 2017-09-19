# uri = URI.parse(ENV["REDISTOGO_URL"])
# REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# Resque.redis = REDIS
if ENV["REDISCLOUD_URL"]
  $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end
