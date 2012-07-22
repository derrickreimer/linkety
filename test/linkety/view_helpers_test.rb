require File.dirname(__FILE__) + '/../test_helper.rb'

class Linkety::ViewHelpersTest < Test::Unit::TestCase
  include ActionView::Helpers::UrlHelper
  include Linkety::ViewHelpers
  
  attr_accessor :request
  
  def request_for_path(path)
    request = MiniTest::Mock.new
    request.expect(:fullpath, path)
    request
  end
  
  def extract_text(tag)
    groups = /<a.*>(.*)<\/a>/.match(tag)
    text = groups ? groups[1].to_s : ""
  end
  
  def extract_attribute(attribute, tag)
    groups = /#{attribute}=("|')([^"']*)("|')/.match(tag)
    klasses = groups ? groups[2] : ""
    klasses.split(' ') || []
  end
  
  def extract_classes(tag)
    extract_attribute("class", tag)
  end
  
  def extract_href(tag)
    extract_attribute("href", tag)[0] || ""
  end
  
  context "test helpers" do
    context "#extract_classes" do
      should "work with single quotes" do
        tag = "<a href='http://google.com' class='one two three'>Google</a>"
        assert_equal ["one", "two", "three"], extract_classes(tag)
      end

      should "work with double quotes" do
        tag = "<a href='http://google.com' class=\"one two three\">Google</a>"
        assert_equal ["one", "two", "three"], extract_classes(tag)
      end
      
      should "return an empty array if no classes" do
        tag = "<a href='http://google.com' class=''>Google</a>"
        assert_equal [], extract_classes(tag)
      end
      
      should "return an empty array if class attribute not set" do
        tag = "<a href='http://google.com'>Google</a>"
        assert_equal [], extract_classes(tag)
      end
    end

    context "#extract_href" do
      should "return the URL" do
        tag = "<a href='http://google.com' class='one two three'>Google</a>"
        assert_equal "http://google.com", extract_href(tag)
      end
      
      should "return an empty string if href is not set" do
        tag = "<a class='one two three'>Google</a>"
        assert_equal "", extract_href(tag)
      end
    end
    
    context "#extract_text" do
      should "return the anchor text" do
        tag = "<a href='http://google.com' class='one two three'>Google</a>"
        assert_equal "Google", extract_text(tag)
      end
      
      should "return an empty string if link has not text" do
        tag = "<a href='http://google.com' class='one two three'></a>"
        assert_equal "", extract_text(tag)
      end
    end
  end
  
  context "#active_link_to_if" do
    should "be active if true" do
      tag = active_link_to_if(true, "Foobar", "http://google.com")
      assert extract_classes(tag).include?("active")
    end
    
    should "be inactive if false" do
      tag = active_link_to_if(false, "Foobar", "http://google.com")
      assert extract_classes(tag).include?("inactive")
    end
    
    should "change inactive URL to a hash" do
      tag = active_link_to_if(false, "Foobar", "http://google.com")
      assert_equal "#", extract_href(tag)
    end
    
    should "append to given classes" do
      tag = active_link_to_if(false, "Foobar", "http://google.com", :class => "one two")
      klasses = extract_classes(tag)
      assert klasses.include?("one")
      assert klasses.include?("two")
      assert klasses.include?("inactive")
    end
    
    should "use custom active class" do
      tag = active_link_to_if(true, "Foobar", "http://google.com", :active_class => "enabled")
      assert extract_classes(tag).include?("enabled")
    end
    
    should "use custom inactive class" do
      tag = active_link_to_if(false, "Foobar", "http://google.com", :active_class => "disabled")
      assert extract_classes(tag).include?("disabled")
    end
    
    should "use custom inactive URL" do
      tag = active_link_to_if(false, "Foobar", "http://google.com", :inactive_url => "http://yahoo.com")
      assert_equal "http://yahoo.com", extract_href(tag)
    end
    
    should "have the right text" do
      tag = active_link_to_if(true, "Foobar", "http://google.com")
      assert_equal "Foobar", extract_text(tag)
    end
  end
  
  context "#current_link_to_if" do
    should "match current for full URL links" do
      @request = request_for_path("/search")
      tag = current_link_to("Google", "http://google.com/search")
      assert extract_classes(tag).include?("current")
    end
    
    should "not match different full URL links" do
      @request = request_for_path("http://google.com/foo")
      tag = current_link_to("Google", "http://google.com/search")
      assert !extract_classes(tag).include?("current")
    end
    
    should "match current for path links" do
      @request = request_for_path("/search")
      tag = current_link_to("Google", "/search")
      assert extract_classes(tag).include?("current")
    end
    
    should "not match different path links" do
      @request = request_for_path("/foo")
      tag = current_link_to("Google", "http://google.com/search")
      assert !extract_classes(tag).include?("current")
    end
    
    should "match root path" do
      @request = request_for_path("/")
      tag = current_link_to("Google", "http://google.com/")
      assert extract_classes(tag).include?("current")
    end
    
    should "match current with a query string" do
      @request = request_for_path("/search?q=ruby")
      tag = current_link_to("Google", "http://google.com/search")
      assert extract_classes(tag).include?("current")
    end
    
    should "match current with additional segments" do
      @request = request_for_path("/search/foo/bar")
      tag = current_link_to("Google", "http://google.com/search")
      assert extract_classes(tag).include?("current")
    end
    
    should "use custom current class" do
      @request = request_for_path("/search")
      tag = current_link_to("Google", "http://google.com/search", :current_class => "active")
      assert extract_classes(tag).include?("active")
    end
    
    should "use custom pattern" do
      @request = request_for_path("/foobar")
      tag = current_link_to("Google", "http://google.com/search", :pattern => /foobar/)
      assert extract_classes(tag).include?("current")
    end
    
    should "have the right text" do
      @request = request_for_path("/")
      tag = current_link_to("Foobar", "http://google.com/")
      assert_equal "Foobar", extract_text(tag)
    end
  end
end