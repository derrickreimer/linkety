# Linkety

Linkety is a collection of handy link helpers for Rails views. Helpers include
`current_link_to`, `active_link_to_if`, and `inactive_link_to_if`.

## Installation

Add this line to your application's Gemfile:

    gem 'linkety'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linkety

## Usage

Sometimes you want to add a specific class to a link if you are currently on the
page the link points to. Navigation menus are a classic example of this scenario.
Simply use the `current_link_to` like so:

```html
<ul class="main-menu">
  <li><%= current_link_to "Home", home_url %></li>
</ul>
```

When you are on the home page, this helper with output a link with a `current`
class. You can change the default class name by defining a `:current_class` option.
If you want match the current URL against a custom regex instead of an exact path match, 
simply pass in a regex object for the `:pattern` option.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
