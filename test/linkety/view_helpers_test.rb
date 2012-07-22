require File.dirname(__FILE__) + '/../test_helper.rb'

class Linkety::ViewHelpersTest < Test::Unit::TestCase
  def setup
    @view = ActionView::Base.new
    @request = ActionController::TestRequest.new
  end
  
  def extract_text(tag)
    
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
  end
  
  context "#active_link_to_if" do
    should "be active if true" do
      tag = @view.active_link_to_if(true, "Foobar", "http://google.com")
      assert extract_classes(tag).include?("active")
    end
    
    should "be inactive if false" do
      tag = @view.active_link_to_if(false, "Foobar", "http://google.com")
      assert extract_classes(tag).include?("inactive")
    end
    
    should "change inactive URL to a hash" do
      tag = @view.active_link_to_if(false, "Foobar", "http://google.com")
      assert_equal "#", extract_href(tag)
    end
    
    should "append to given classes" do
      tag = @view.active_link_to_if(false, "Foobar", "http://google.com", :class => "one two")
      klasses = extract_classes(tag)
      assert klasses.include?("one")
      assert klasses.include?("two")
      assert klasses.include?("inactive")
    end
    
    should "use custom active class" do
      tag = @view.active_link_to_if(true, "Foobar", "http://google.com", :active_class => "enabled")
      assert extract_classes(tag).include?("enabled")
    end
    
    should "use custom inactive class" do
      tag = @view.active_link_to_if(false, "Foobar", "http://google.com", :active_class => "disabled")
      assert extract_classes(tag).include?("disabled")
    end
    
    should "use custom inactive URL" do
      tag = @view.active_link_to_if(false, "Foobar", "http://google.com", :inactive_url => "http://yahoo.com")
      assert_equal "http://yahoo.com", extract_href(tag)
    end
  end
end