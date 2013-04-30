# Guard::Strainer

```guard-strainer``` will automatically execute a Strainerfile for a watched chef-repo or cookbook when it detects changes

## Installation

Add to your chef-repo or cookbook's Gemfile:

    gem 'guard-strainer'

Or install the gem (make sure you also have [Guard](https://github.com/guard/guard):

    $ gem install guard-strainer

Finally add the guard-strainer definition to your Guardfile:

    guard init strainer

## Usage
Please read the [Guard usage doc](http://github.com/guard/guard#readme)

## Author
[Stafford Brunk](https://github.com/wingrunr21)
