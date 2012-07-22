require "linkety/view_helpers"

module Linkety
  class Railtie < Rails::Railtie
    initializer "linkety.view_helpers" do
      ActionView::Base.send(:include, ViewHelpers)
    end
  end
end