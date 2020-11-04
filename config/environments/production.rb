# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger        = SyslogLogger.new

# http://www.sevenmike.com/2011/03/08/cut-rails-log/
config.logger = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}_#{Date.today.to_s}.log", "daily")

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# http://rails-bestpractices.com/posts/40-use-asset_host-for-production-server
# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"
# config.action_controller.asset_host = "http://assets.wxianfeng.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false

Migrator.offer_migration_when_available = true
