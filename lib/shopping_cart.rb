require 'shopping_cart/engine'
require 'haml'
require 'aasm'
require 'wicked'
require 'bootstrap-sass'
require 'jquery-rails'
require 'coffee-rails'
require 'turbolinks'
require 'cancancan'

module ShoppingCart
  def self.load_files
    Dir['app/services/shopping_cart/*.rb']
  end
end
