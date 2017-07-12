require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module Sampleapp
  class Application < Rails::Application
  end
end
