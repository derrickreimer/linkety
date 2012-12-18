require 'uri'

module Linkety
  module ViewHelpers
    # Public: Generates an HTML anchor tag in either an active or inactive 
    # state, depending on a given truth value.
    # 
    # If the truth value is true, this method will generate a link 
    # that has an 'active' class (or whatever class name you optionally
    # specify for :active_class). 
    #
    # If the truth value is false, this method will generate a link by 
    # default with an href of '#' (or whatever you specify for :inactive_url) 
    # and with an added 'inactive' class (or whatever you specify for 
    # :inactive_class).
    #
    # truth   - A Boolean truth value.
    # text    - A String of anchor text.
    # url     - A String URL.
    # options - A Hash of options. In addition to the regular #link_to options,
    #           you may set the following:
    #           :active_class   - A String class to add if the link is active 
    #                             (default: 'active').
    #           :inactive_class - A String class to add if the link is inactive
    #                             (default: 'inactive').
    #           :inactive_url   - A String URL for when the link is inactive
    #                             (default: '#').
    #
    # Returns a String anchor tag.
    def active_link_to_if(truth, text, url, options = {})
      active_class   = options[:active_class]   || "active"
      inactive_class = options[:inactive_class] || "inactive"
      inactive_url   = options[:inactive_url]   || "#"
      klasses        = (options.delete(:class)  || "").split(' ')
      
      klasses << (truth ? active_class : inactive_class)
      url = inactive_url unless truth
      
      link_to(text, url, options.merge(:class => klasses.join(' ')))
    end
    
    # Public: Generates an HTML anchor tag in either an inactive or active 
    # state, depending on a given truth value. (See #active_link_to_if for more 
    # details.)
    #
    # truth   - A Boolean truth value.
    # text    - A String of anchor text.
    # url     - A String URL.
    # options - A Hash of options. In addition to the regular #link_to options,
    #           you may set the following:
    #           :active_class   - A String class to add if the link is active 
    #                             (default: 'active').
    #           :inactive_class - A String class to add if the link is inactive
    #                             (default: 'inactive').
    #           :inactive_url   - A String URL for when the link is inactive
    #                             (default: '#').
    #
    # Returns a String anchor tag.
    def inactive_link_to_if(truth, text, url, options = {})
      active_link_to_if(!truth, text, url, options)
    end
    
    # Public: Generates an HTML anchor tag that has a 'current' class if
    # the current request path matches the link path.
    #
    # text    - A String of anchor text.
    # url     - A String URL.
    # options - A Hash of options. In addition to the regular #link_to options,
    #           you may set the following:
    #           :current_class - The String class to add if the link is current
    #                            (default: 'current').
    #           :pattern       - A Regexp pattern to match against the current 
    #                            path (default: the link URL path).
    #
    # Returns a String anchor tag.
    def current_link_to(text, url, options = {})
      current_class = options[:current_class] || "current"
      klasses       = (options.delete(:class) || "").split(' ')
      href_path     = extract_path(url)
      pattern       = options[:pattern] || Regexp.new(href_path)

      klasses << current_class if _current_path =~ pattern
      link_to(text, url, options.merge(:class => klasses.join(' ')))
    end
    
    # Private: The path of the current request.
    #
    # Returns a String.
    def _current_path
      raise "A Request object must be present" unless request
      fullpath = request.fullpath.split("?")[0]
      extract_path(fullpath)
    end
    
    # Private: Extract just the path portion of a URL without the query string.
    #
    # uri - A String URL.
    #
    # Examples
    #
    #   extract_path("http://google.com/foo/bar")
    #   => "/foo/bar"
    #
    #   extract_path("/foo/bar/que?order=asc")
    #   => "/foo/bar/que"
    #
    # Returns a String.
    def extract_path(uri)
      parsed_uri = URI(uri)
      parsed_uri.path
    end
  end
end