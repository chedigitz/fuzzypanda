# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)
FB_APP_ID = '309232419150548'
FB_SECRET_KEY = 'd2cea9bd1d33224ff4581f7c61476a76'

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'webrick/https'
require 'rake'
Bundler.require(:default, PADRINO_ENV)

##
# Enable devel logging
#
#Padrino::Logger::Config[:development][:log_level]  = :devel
# Padrino::Logger::Config[:development][:log_static] = true
#




##
# Add your before load hooks here
#
Padrino.before_load do

end

##
# Add your after load hooks here
#
Padrino.after_load do

end
Padrino.use Rack::Session::Cookie, :session_secret => '23f112b248acd1bb8d0ffe4755c4763103d53f69f748cadc0db124752dbd0330'


Padrino::Logger::Config[:development][:stream] = :stdout
Padrino::Logger::Config[:production] = { :log_level => :info, :stream => :stdout}
Padrubi::Logger::Config[:production] = { :log_level => :debug, :stream => :stdout}
Padrino.load! 
