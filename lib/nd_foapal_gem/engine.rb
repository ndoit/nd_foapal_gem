module NdFoapalGem
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    require 'jquery-ui-rails'
    require 'foundation-rails'
    isolate_namespace NdFoapalGem
    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
