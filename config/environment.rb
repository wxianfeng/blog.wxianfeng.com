# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'

RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
# RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  config.frameworks -= [ :active_resource ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services )

  # I need the localization plugin to load first
  # Otherwise, I can't localize plugins <= localization
  # Forcing manually the load of the textfilters plugins fixes the bugs with apache in production.
  config.plugins = [ :localization, :all ]
  
  config.load_paths += %W(
    vendor/rubypants
    vendor/akismet
    vendor/flickr
    vendor/uuidtools/lib
    vendor/rails/railties
    vendor/rails/railties/lib
    vendor/rails/actionpack/lib
    vendor/rails/activesupport/lib
    vendor/rails/activerecord/lib
    vendor/rails/actionmailer/lib
    app/apis
    ).map {|dir| "#{RAILS_ROOT}/#{dir}"}.select { |dir| File.directory?(dir) }

  # Declare the gems in vendor/gems, so that we can easily freeze and/or
  # install them.
  config.gem 'htmlentities'
  config.gem 'json'
  config.gem 'calendar_date_select'
  config.gem 'bluecloth', :version => '~> 2.0.5'
  config.gem 'coderay', :version => '~> 0.8'
  config.gem 'mislav-will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate', 
  :source => 'http://gems.github.com'
  config.gem 'RedCloth', :version => '~> 4.2.2'
  config.gem 'panztel-actionwebservice', :version => '2.3.5', :lib => 'actionwebservice'
  config.gem 'addressable', :version => '~> 2.1.0', :lib => 'addressable/uri'
  config.gem 'mini_magick', :version => '~> 1.2.5', :lib => 'mini_magick'

  # added by wxianfeng
  config.gem 'httpclient' , :lib => 'httpclient'
  config.gem 'hpricot' , :lib => 'hpricot'
  
  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  # config.action_controller.session_store = :active_record_store
  config.action_controller.session = { :key => "_typo_session", :secret => "8d7879bd56b9470b659cdcae88792622" }
  
  # Disable use of the Accept header, since it causes bad results with our
  # static caching (e.g., caching an atom feed as index.html).
  config.action_controller.use_accept_header = false

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :email_notifier, :web_notifier
end

# Load included libraries.
require 'rubypants'
require 'uuidtools'

require 'migrator'
require 'rails_patch/active_record'
require 'rails_patch/ruby_methods'
require 'login_system'
require 'typo_version'
$KCODE = 'u'
require 'jcode'
require 'transforms'

# added by wxianfeng
# require 'httpclient'
# require "hpricot"
require 'thread'


ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :long_weekday => '%a %B %e, %Y %H:%M'
  )

ActionMailer::Base.default_charset = 'utf-8'

# I wanted to put this as a "setup" page, but it seems I can't catch the 
# exception fast enough and get a 500 error
#if RAILS_ENV != 'test'
#  begin
#    ActiveRecord::Base.connection.select_all("select * from sessions")
#  rescue
#    begin
#      ActiveRecord::Base.connection.current_database
#      Migrator.migrate
#    rescue
#      # if there are no database, migrator doesn't no start
# use case : rake db:create in rails tasks
#    end
#  end
#end

# Work around interpolation deprecation problem: %d is replaced by
# {{count}}, even when we don't want them to.
# FIXME: We should probably fully convert to standard Rails I18n.
class I18n::Backend::Simple
  def interpolate(locale, string, values = {})
    interpolate_without_deprecated_syntax(locale, string, values)
  end
end

if RAILS_ENV != 'test'
  begin
    mail_settings = YAML.load(File.read("#{RAILS_ROOT}/config/mail.yml"))
    ActionMailer::Base.delivery_method = mail_settings['method']
    #     ActionMailer::Base.server_settings = mail_settings['settings']
    ActionMailer::Base.smtp_settings = mail_settings['settings']
  rescue
    # Fall back to using sendmail by default
    # ActionMailer::Base.delivery_method = :sendmail
  end
end

FLICKR_KEY='cf957bd7556d956c9d1a72fedac52ef2'


ExceptionNotification::Notifier.exception_recipients = %w(wang.fl1429@gmail.com)

# undefined local variable or method `version_requirements' for
# http://www.redmine.org/boards/2/topics/22358?r=22362
# OR this method: http://excid3.com/blog/2011/02/undefined-local-variable-or-method-version_requirements-for-nameerror/
if Gem::VERSION >= "1.3.6"
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

ActionController::Base.asset_host = Proc.new { |source|
 if RAILS_ENV == 'production'
  if source.start_with?('/images/theme') or source.start_with?('/stylesheets/theme') or source.start_with?('/javascripts/theme')
    "http://wxianfeng.com"
  else
    "http://assets.wxianfeng.com"
  end
end
}