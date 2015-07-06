require 'rubygems'
require 'bundler'
Bundler.require(:default)


#require 'sinatra'
#require 'warden'
#require 'digest/sha1'
#require 'securerandom'
require 'rack-flash'
require 'active_record'
#require 'mysql2'
#require 'json'
#require 'byebug'

require './config/app_secret_key'

Dir[File.dirname(__FILE__) + '/models/**/*.rb'].each {|file| require file }
