require 'assert/version'

# The Module Assert will allow you to compare and diff 2 data structures.
# This method can accept any complex data structure (types are limited to hashes,
# arrays and scalar values).  In other words, this method can take an array of hashes,
# a hash with arrays of hashes within, etc.
#
# Author::    Reynold Miguel
# Date:: 1/1/2017
#
# This method assert_identical accepts any complex data structure.
# There are 4 comparison states:
## equal - the 2 compared values are equal
## unequal - the 2 compared values are unequal
## missing - the first element is missing for comparison
## surplus - the second element has an extra value for comparison

module Assert
  class Asserter

    def assert_identical!(first_element, second_element)
      @data = assert_identical(first_element, second_element)
      self
    end

    # assert_identical, diffs 2 data structures.  This method can accept any complex data structure (types are limited to hashes,
    # arrays and scalar values)
    # Params:
    # +first_element+:: First data structure to compare
    # +second_element+:: Second data structure to compare
    def assert_identical(first_element, second_element)
      _assert_identical(:first_element => first_element, :second_element => second_element)
    end

    private
    def _assert_identical(args)
      data = {:first_element => nil, :second_element => nil, :compare_type => nil}
      data[:first_element] = value_data_for(args[:first_element]) if args[:first_element]
      data[:second_element] = value_data_for(args[:second_element]) if args[:second_element]
      if data[:first_element] && data[:second_element] && data[:first_element][:type] == data[:second_element][:type]
        data[:compare_type] = data[:first_element][:type]
      end

      #determine type of comparison method to call (array or hash), else perform '==' comparison
      assert_identical_method = "_assert_identical_#{data[:compare_type]}"
      if data[:compare_type] && respond_to?(assert_identical_method, true)
        equal, details = __send__(assert_identical_method, args[:first_element], args[:second_element])
      else
        equal = (args[:first_element] == args[:second_element])
      end

      #set state
      if args[:first_element] && args[:second_element]
        data[:state] = (equal ? :equal : :unequal)
      elsif args[:first_element]
        data[:state] = :missing
      elsif args[:second_element]
        data[:state] = :surplus
      end

      #set details if nesting is present in data structures
      data[:details] = details if details
      data
    end

    # _assert_identical_array, handles array comparison
    def _assert_identical_array(first_element, second_element)
      equal = true
      details = []
      (0...first_element.size).each do |i|
        if i > second_element.size - 1
          subdata = _assert_identical(:first_element => first_element[i])
          equal = false
        else
          subdata = _assert_identical(:first_element => first_element[i], :second_element => second_element[i])
          equal &&= (subdata[:state] == :equal)
        end
        #append to array
        details << [i, subdata]
      end
      if second_element.size > first_element.size
        equal = false
        (first_element.size .. second_element.size-1).each do |i|
          subdata = _assert_identical(:second_element => second_element[i])
          #append to array
          details << [i, subdata]
        end
      end
      [equal, details]
    end

    # _assert_identical_hash, handles hash comparison
    def _assert_identical_hash(first_element, second_element)
      equal = true
      details = []
      first_element.keys.each do |k|
        if second_element.include?(k)
          subdata = _assert_identical(:first_element => first_element[k], :second_element => second_element[k])
          equal &&= (subdata[:state] == :equal)
        else
          subdata = _assert_identical(:first_element => first_element[k])
          equal = false
        end
        #append to set
        details << [k, subdata]
      end
      (second_element.keys - first_element.keys).each do |k|
        equal = false
        subdata = _assert_identical(:second_element => second_element[k])
        #append to set
        details << [k, subdata]
      end
      [equal, details]
    end

    # type_of , determine the type of object
    # Params:
    # +value+:: compared value
    def type_of(value)
      case value
        when Integer then :number
        else value.class.to_s.downcase.to_sym
      end
    end

    # value_data_for, set the object size, and type
    # Params:
    # +value+:: compared value
    def value_data_for(value)
      data = {:value => value, :type => type_of(value)}
      data[:size] = value.size if value.is_a?(Enumerable)
      data
    end
  end
end
