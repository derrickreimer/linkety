$:.unshift File.expand_path('../../lib', __FILE__)

require 'linkety'
require 'minitest/autorun'
require 'shoulda-context'

require 'active_support'
require 'action_view'
require 'action_dispatch'
require 'action_controller/test_case'

ActionView::Base.send(:include, Linkety::ViewHelpers)