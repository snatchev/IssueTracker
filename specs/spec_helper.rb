ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'debugger'

require_relative '../issue_tracker'
