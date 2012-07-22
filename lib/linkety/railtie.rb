require "linkety/view_helpers"

module Linkety
  class Railtie < Rails::Railtie
    initializer "linkety.view_helpers" do
      ActionView::Helpers::UrlHelper.send :include, ViewHelpers
    end
  end
end