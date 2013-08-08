# Guard::Strainer
[![Build Status](https://travis-ci.org/wingrunr21/guard-strainer.png)](https://travis-ci.org/wingrunr21/guard-strainer) [![Gem Version](https://badge.fury.io/rb/guard-strainer.png)](http://badge.fury.io/rb/guard-strainer)

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

## Options

```ruby
:standalone => true                         # set to true for cookbook operation. Default false.
:all_on_pass => false                       # set to true to run all Strainerfiles on pass. Default true.
:all_on_start => false                      # set to true to run all Strainerfiles on start. Default true.
:fail_fast => false                         # set to true to fail immediately upon any non-zero exit code. Default true.
:except => ['foodcritic']                   # labels to ignore in the Strainerfiles
:only => ['foodcritic']                     # labels to include in the Strainerfiles
:cookbooks_path => '/path/to/cookbooks'     # path to the cookbook store
:config => "/path/to/client.rb"             # path to the knife.rb/client.rb config
:debug => true                              # set to true to enable debugging log output. Default false.
:color => false                             # set to false to disable colored output. Default is true
```

## Development

Pull requests are welcome! Please try to follow these rules for contributions:

* Please create a topic branch for every unique change
* Please make sure you create tests for your new features
* Please update the README as applicable
* Please **do not change** the version number

## Author
[Stafford Brunk](https://github.com/wingrunr21)
