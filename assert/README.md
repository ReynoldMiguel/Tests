# Assert

Assert will allow you to compare and diff 2 data structures.  This method can accept any complex data structure (types 
are limited to hashes, arrays and scalar values).  In other words, this method can take an array of hashes, a hash with 
arrays of hashes within, etc.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assert'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assert

## Usage

In the Assert Module there is a method called assert_identical.  

This method accepts any complex data structure (types can be limited to hashes, arrays and scalar values).  
In other words, this method can take an array of hashes, a hash with arrays of hashes within, etc.  The limit of nested 
data structures is infinite.  

```
require 'assert'

Assert.identical?(object, my_other_object)
```

## Development

After checking out the repo, run `bundle install` to install dependencies. 
Then, run `rake test` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, 
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to 
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reynoldmiguel/assert. This project is intended
 to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the 
 [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## (Required) Programming Exercise — Assert Identical
Your task is to build a module method called assert_identical.  Here are the minimum specifications...
Minimum Requirements:

* This method should exist as a module method.  The module that it resides in should be named Assert
* This method should gracefully fail when passed in anything other than 2 identically structured objects.
* When values do not match between the two structures, the raised StandardError messaging should include the following...
  * A dot-notated location of the key with the unequal values (using the second example above, a dot-notated key of: 
  [1].key3.[0].subkey_1 has a value of: ['g', 'h', 'i'])
  * The unequal values themselves
  * If there are multiple values that failed for a single run of assert_identical, each failure should be displayed as part 
of the same error message with the information mentioned above provided for each of them.
* Unit tests should be written to test the limits of your method and ensure that it can reliably be used in a testing environment.
* Track the progress of your implementation via a github account.  A link to your work should be provided upon completion.
* Be sure to add a README that discusses the following...
* Installation instructions 
  * What it does
  * How to use it
  * How to run the unit tests
  * Examples
  * Detailed list of features
  * Finally, add a section that describes your approach, future enhancements and compromises made.

#### Optional Bonus Requirements
* Add the ability to pass in a list of keys to not run assertions against.
* Is there something lacking that you feel would be a very useful feature?  
* Please add that functionality, but be ready to defend the importance of any new features you may add.
* For any bonus requirements, please don't forget to add unit tests!

Prerequisites
* Must be written in ruby
* Please use minitest for your unit testing purposes.
* Each method should have no more than 50 lines in it.
* Must be modular and loadable in a pry/irb session