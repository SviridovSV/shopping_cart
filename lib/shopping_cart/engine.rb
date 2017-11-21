module ShoppingCart
  class Engine < ::Rails::Engine

    isolate_namespace ShoppingCart

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer 'shopping_cart', after: :load_config_initializers do |_app|
      ShoppingCart.load_files.each do |file|
        require_relative File.join('../..', file)
      end
    end
  end
end
