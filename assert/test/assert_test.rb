require 'test_helper'
require 'assert'
# For debugging purposes
require 'pp'

describe Assert do

  describe Assert::Asserter do
    before do
      @asserter = Assert::Asserter.new
    end

    describe '#assert_identical', 'generates correct data for' do

      specify "simple objects with same and differing values" do
        actual=@asserter.assert_identical(
            {
            key1: 'value 1',
            key2: 3,
            key3: ['a', 'b', 'c'],
            },
            {
            key1: 'value 100',
            key2: 30,
            key3: ['c', 'b', 'a'],
            }
        )
        #pp actual
        expected = {:first_element=>
                        {:value=>{:key1=>"value 1", :key2=>3, :key3=>["a", "b", "c"]},
                         :type=>:hash,
                         :size=>3},
                    :second_element=>
                        {:value=>{:key1=>"value 100", :key2=>30, :key3=>["c", "b", "a"]},
                         :type=>:hash,
                         :size=>3},
                    :compare_type=>:hash,
                    :state=>:unequal,
                    :details=>
                        [[:key1,
                          {:first_element=>{:value=>"value 1", :type=>:string},
                           :second_element=>{:value=>"value 100", :type=>:string},
                           :compare_type=>:string,
                           :state=>:unequal}],
                         [:key2,
                          {:first_element=>{:value=>3, :type=>:number},
                           :second_element=>{:value=>30, :type=>:number},
                           :compare_type=>:number,
                           :state=>:unequal}],
                         [:key3,
                          {:first_element=>{:value=>["a", "b", "c"], :type=>:array, :size=>3},
                           :second_element=>{:value=>["c", "b", "a"], :type=>:array, :size=>3},
                           :compare_type=>:array,
                           :state=>:unequal,
                           :details=>
                               [[0,
                                 {:first_element=>{:value=>"a", :type=>:string},
                                  :second_element=>{:value=>"c", :type=>:string},
                                  :compare_type=>:string,
                                  :state=>:unequal}],
                                [1,
                                 {:first_element=>{:value=>"b", :type=>:string},
                                  :second_element=>{:value=>"b", :type=>:string},
                                  :compare_type=>:string,
                                  :state=>:equal}],
                                [2,
                                 {:first_element=>{:value=>"c", :type=>:string},
                                  :second_element=>{:value=>"a", :type=>:string},
                                  :compare_type=>:string,
                                  :state=>:unequal}]]}]]}
        assert(actual == expected)
      end

      specify "same strings" do
        actual = @asserter.assert_identical("foo", "foo")
        #pp actual
        expected = {
            :state => :equal,
            :first_element => {:value => "foo", :type => :string},
            :second_element => {:value => "foo", :type => :string},
            :compare_type => :string
        }
        assert(actual == expected)
      end

      specify "differing strings" do
        actual = @asserter.assert_identical("foo", "bar")
        #pp actual
        expected = {
            :state => :unequal,
            :first_element => {:value => "foo", :type => :string},
            :second_element => {:value => "bar", :type => :string},
            :compare_type => :string
        }
        assert(actual == expected)
      end

      specify "same numbers" do
        actual = @asserter.assert_identical(1, 1)
        #pp actual
        expected = {
            :state => :equal,
            :first_element => {:value => 1, :type => :number},
            :second_element => {:value => 1, :type => :number},
            :compare_type => :number
        }
        assert(actual == expected)
      end

      specify "differing numbers" do
        actual = @asserter.assert_identical(1, 2)
        #pp actual
        expected = {
            :state => :unequal,
            :first_element => {:value => 1, :type => :number},
            :second_element => {:value => 2, :type => :number},
            :compare_type => :number
        }
        assert(actual == expected)
      end

      specify "values of differing simple types" do
        actual = @asserter.assert_identical("foo", 1)
        #pp actual
        expected = {
            :state => :unequal,
            :first_element => {:value => "foo", :type => :string},
            :second_element => {:value => 1, :type => :number},
            :compare_type => nil
        }
        assert(actual == expected)
      end

      specify "values of differing complex types" do
        actual = @asserter.assert_identical("foo", %w(bang boom))
        expected = {
            :state => :unequal,
            :first_element => {:value => "foo", :type => :string},
            :second_element => {:value => %w(bang boom), :type => :array, :size => 2},
            :compare_type => nil
        }
        assert(actual == expected)
      end

      specify "arrays of same size but with differing elements" do
        actual = @asserter.assert_identical(["foo", "bar"], ["foo", "baz"])
        expected = {
            :state => :unequal,
            :first_element => {:value => ["foo", "bar"], :type => :array, :size => 2},
            :second_element => {:value => ["foo", "baz"], :type => :array, :size => 2},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foo", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "baz", :type => :string},
                    :compare_type => :string
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "arrays with inserted elements" do
        actual = @asserter.assert_identical(
            %w(a b),
            %w(a 1 2 b),
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => %w(a b), :type => :array, :size => 2},
            :second_element => {:value => %w(a 1 2 b), :type => :array, :size => 4},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "a", :type => :string},
                    :second_element => {:value => "a", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => "b", :type => :string},
                    :second_element => {:value => "1", :type => :string},
                    :compare_type => :string
                }],
                [2, {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "2", :type => :string},
                    :compare_type => nil
                }],
                [3, {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "b", :type => :string},
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested arrays of same size but with differing elements" do
        actual = @asserter.assert_identical(
            [["foo", "bar"], ["baz", "jelly"]],
            [["foo", "biz"], ["baz", "peanut"]]
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => [["foo", "bar"], ["baz", "jelly"]], :type => :array, :size => 2},
            :second_element => {:value => [["foo", "biz"], ["baz", "peanut"]], :type => :array, :size => 2},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :unequal,
                    :first_element => {:value => ["foo", "bar"], :type => :array, :size => 2},
                    :second_element => {:value => ["foo", "biz"], :type => :array, :size => 2},
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "foo", :type => :string},
                            :second_element => {:value => "foo", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "biz", :type => :string},
                            :compare_type => :string
                        }]
                    ]
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => ["baz", "jelly"], :type => :array, :size => 2},
                    :second_element => {:value => ["baz", "peanut"], :type => :array, :size => 2},
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "baz", :type => :string},
                            :second_element => {:value => "baz", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => "jelly", :type => :string},
                            :second_element => {:value => "peanut", :type => :string},
                            :compare_type => :string
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested arrays with differing elements" do
        actual = @asserter.assert_identical(
            [
                "foo",
                ["bar", ["baz", "jelly"]],
                "ying",
                ["blargh", "zing", "fooz", ["raz", ["jack"]]]
            ],
            [
                "foz",
                "bar",
                "ying",
                ["blargh", "gragh", 1, ["raz", ["jameson"]]]
            ]
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => [
                    "foo",
                    ["bar", ["baz", "jelly"]],
                    "ying",
                    ["blargh", "zing", "fooz", ["raz", ["jack"]]]
                ],
                :type => :array,
                :size => 4
            },
            :second_element => {
                :value => [
                    "foz",
                    "bar",
                    "ying",
                    ["blargh", "gragh", 1, ["raz", ["jameson"]]]
                ],
                :type => :array,
                :size => 4
            },
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :unequal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foz", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => ["bar", ["baz", "jelly"]], :type => :array, :size => 2},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => nil
                }],
                [2, {
                    :state => :equal,
                    :first_element => {:value => "ying", :type => :string},
                    :second_element => {:value => "ying", :type => :string},
                    :compare_type => :string
                }],
                [3, {
                    :state => :unequal,
                    :first_element => {
                        :value => ["blargh", "zing", "fooz", ["raz", ["jack"]]],
                        :type => :array,
                        :size => 4
                    },
                    :second_element => {
                        :value => ["blargh", "gragh", 1, ["raz", ["jameson"]]],
                        :type => :array,
                        :size => 4
                    },
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "blargh", :type => :string},
                            :second_element => {:value => "blargh", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => "zing", :type => :string},
                            :second_element => {:value => "gragh", :type => :string},
                            :compare_type => :string
                        }],
                        [2, {
                            :state => :unequal,
                            :first_element => {:value => "fooz", :type => :string},
                            :second_element => {:value => 1, :type => :number},
                            :compare_type => nil
                        }],
                        [3, {
                            :state => :unequal,
                            :first_element => {:value => ["raz", ["jack"]], :type => :array, :size => 2},
                            :second_element => {:value => ["raz", ["jameson"]], :type => :array, :size => 2},
                            :compare_type => :array,
                            :details => [
                                [0, {
                                    :state => :equal,
                                    :first_element => {:value => "raz", :type => :string},
                                    :second_element => {:value => "raz", :type => :string},
                                    :compare_type => :string
                                }],
                                [1, {
                                    :state => :unequal,
                                    :first_element => {:value => ["jack"], :type => :array, :size => 1},
                                    :second_element => {:value => ["jameson"], :type => :array, :size => 1},
                                    :compare_type => :array,
                                    :details => [
                                        [0, {
                                            :state => :unequal,
                                            :first_element => {:value => "jack", :type => :string},
                                            :second_element => {:value => "jameson", :type => :string},
                                            :compare_type => :string
                                        }]
                                    ]
                                }]
                            ]
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify " arrays with surplus elements" do
        actual = @asserter.assert_identical(["foo", "bar"], ["foo", "bar", "baz", "jelly"])
        expected = {
            :state => :unequal,
            :first_element => {:value => ["foo", "bar"], :type => :array, :size => 2},
            :second_element => {:value => ["foo", "bar", "baz", "jelly"], :type => :array, :size => 4},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foo", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :equal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => :string
                }],
                [2, {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "baz", :type => :string},
                    :compare_type => nil
                }],
                [3, {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "jelly", :type => :string},
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify " arrays with missing elements" do
        actual = @asserter.assert_identical(["foo", "bar", "baz", "jelly"], ["foo", "bar"])
        expected = {
            :state => :unequal,
            :first_element => {:value => ["foo", "bar", "baz", "jelly"], :type => :array, :size => 4},
            :second_element => {:value => ["foo", "bar"], :type => :array, :size => 2},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foo", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :equal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => :string
                }],
                [2, {
                    :state => :missing,
                    :first_element => {:value => "baz", :type => :string},
                    :second_element => nil,
                    :compare_type => nil
                }],
                [3, {
                    :state => :missing,
                    :first_element => {:value => "jelly", :type => :string},
                    :second_element => nil,
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested arrays with surplus elements" do
        actual = @asserter.assert_identical(
            ["foo", ["bar", "baz"], "ying"],
            ["foo", ["bar", "baz", "jelly", "blargh"], "ying"]
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => ["foo", ["bar", "baz"], "ying"], :type => :array, :size => 3},
            :second_element => {:value => ["foo", ["bar", "baz", "jelly", "blargh"], "ying"], :type => :array, :size => 3},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foo", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => ["bar", "baz"], :type => :array, :size => 2},
                    :second_element => {:value => ["bar", "baz", "jelly", "blargh"], :type => :array, :size => 4},
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "bar", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :equal,
                            :first_element => {:value => "baz", :type => :string},
                            :second_element => {:value => "baz", :type => :string},
                            :compare_type => :string
                        }],
                        [2, {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => "jelly", :type => :string},
                            :compare_type => nil
                        }],
                        [3, {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => "blargh", :type => :string},
                            :compare_type => nil
                        }]
                    ]
                }],
                [2, {
                    :state => :equal,
                    :first_element => {:value => "ying", :type => :string},
                    :second_element => {:value => "ying", :type => :string},
                    :compare_type => :string
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested arrays with missing elements" do
        actual = @asserter.assert_identical(
            ["foo", ["bar", "baz", "jelly", "blargh"], "ying"],
            ["foo", ["bar", "baz"], "ying"]
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => ["foo", ["bar", "baz", "jelly", "blargh"], "ying"], :type => :array, :size => 3},
            :second_element => {:value => ["foo", ["bar", "baz"], "ying"], :type => :array, :size => 3},
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :equal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foo", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => ["bar", "baz", "jelly", "blargh"], :type => :array, :size => 4},
                    :second_element => {:value => ["bar", "baz"], :type => :array, :size => 2},
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "bar", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :equal,
                            :first_element => {:value => "baz", :type => :string},
                            :second_element => {:value => "baz", :type => :string},
                            :compare_type => :string
                        }],
                        [2, {
                            :state => :missing,
                            :first_element => {:value => "jelly", :type => :string},
                            :second_element => nil,
                            :compare_type => nil
                        }],
                        [3, {
                            :state => :missing,
                            :first_element => {:value => "blargh", :type => :string},
                            :second_element => nil,
                            :compare_type => nil
                        }]
                    ]
                }],
                [2, {
                    :state => :equal,
                    :first_element => {:value => "ying", :type => :string},
                    :second_element => {:value => "ying", :type => :string},
                    :compare_type => :string
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested arrays with variously differing arrays" do
        actual = @asserter.assert_identical(
            [
                "foo",
                ["bar", ["baz", "jelly"]],
                "ying",
                ["blargh", "zing", "fooz", ["raz", ["jack", "eee", "ffff"]]]
            ],
            [
                "foz",
                "bar",
                "ying",
                ["blargh", "gragh", 1, ["raz", ["jameson"]], ["foreal", ["zap"]]]
            ]
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => [
                    "foo",
                    ["bar", ["baz", "jelly"]],
                    "ying",
                    ["blargh", "zing", "fooz", ["raz", ["jack", "eee", "ffff"]]]
                ],
                :type => :array,
                :size => 4
            },
            :second_element => {
                :value => [
                    "foz",
                    "bar",
                    "ying",
                    ["blargh", "gragh", 1, ["raz", ["jameson"]], ["foreal", ["zap"]]]
                ],
                :type => :array,
                :size => 4
            },
            :compare_type => :array,
            :details => [
                [0, {
                    :state => :unequal,
                    :first_element => {:value => "foo", :type => :string},
                    :second_element => {:value => "foz", :type => :string},
                    :compare_type => :string
                }],
                [1, {
                    :state => :unequal,
                    :first_element => {:value => ["bar", ["baz", "jelly"]], :type => :array, :size => 2},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => nil
                }],
                [2, {
                    :state => :equal,
                    :first_element => {:value => "ying", :type => :string},
                    :second_element => {:value => "ying", :type => :string},
                    :compare_type => :string
                }],
                [3, {
                    :state => :unequal,
                    :first_element => {
                        :value => ["blargh", "zing", "fooz", ["raz", ["jack", "eee", "ffff"]]],
                        :type => :array,
                        :size => 4
                    },
                    :second_element => {
                        :value => ["blargh", "gragh", 1, ["raz", ["jameson"]], ["foreal", ["zap"]]],
                        :type => :array,
                        :size => 5
                    },
                    :compare_type => :array,
                    :details => [
                        [0, {
                            :state => :equal,
                            :first_element => {:value => "blargh", :type => :string},
                            :second_element => {:value => "blargh", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => "zing", :type => :string},
                            :second_element => {:value => "gragh", :type => :string},
                            :compare_type => :string
                        }],
                        [2, {
                            :state => :unequal,
                            :first_element => {:value => "fooz", :type => :string},
                            :second_element => {:value => 1, :type => :number},
                            :compare_type => nil
                        }],
                        [3, {
                            :state => :unequal,
                            :first_element => {:value => ["raz", ["jack", "eee", "ffff"]], :type => :array, :size => 2},
                            :second_element => {:value => ["raz", ["jameson"]], :type => :array, :size => 2},
                            :compare_type => :array,
                            :details => [
                                [0, {
                                    :state => :equal,
                                    :first_element => {:value => "raz", :type => :string},
                                    :second_element => {:value => "raz", :type => :string},
                                    :compare_type => :string
                                }],
                                [1, {
                                    :state => :unequal,
                                    :first_element => {:value => ["jack", "eee", "ffff"], :type => :array, :size => 3},
                                    :second_element => {:value => ["jameson"], :type => :array, :size => 1},
                                    :compare_type => :array,
                                    :details => [
                                        [0, {
                                            :state => :unequal,
                                            :first_element => {:value => "jack", :type => :string},
                                            :second_element => {:value => "jameson", :type => :string},
                                            :compare_type => :string
                                        }],
                                        [1, {
                                            :state => :missing,
                                            :first_element => {:value => "eee", :type => :string},
                                            :second_element => nil,
                                            :compare_type => nil
                                        }],
                                        [2, {
                                            :state => :missing,
                                            :first_element => {:value => "ffff", :type => :string},
                                            :second_element => nil,
                                            :compare_type => nil
                                        }]
                                    ]
                                }]
                            ]
                        }],
                        [4, {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => ["foreal", ["zap"]], :type => :array, :size => 2},
                            :compare_type => nil
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify " hashes of same size but differing elements" do
        actual = @asserter.assert_identical(
            {"foo" => "bar", "baz" => "jelly"},
            {"foo" => "bar", "baz" => "crux"}
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => {"foo" => "bar", "baz" => "jelly"}, :type => :hash, :size => 2},
            :second_element => {:value => {"foo" => "bar", "baz" => "crux"}, :type => :hash, :size => 2},
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :equal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => :string
                }],
                ["baz", {
                    :state => :unequal,
                    :first_element => {:value => "jelly", :type => :string},
                    :second_element => {:value => "crux", :type => :string},
                    :compare_type => :string
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested hashes of same size but differing elements" do
        actual = @asserter.assert_identical(
            {"one" => {"foo" => "bar", "baz" => "jelly"}, :two => {"ying" => 1, "zing" => :zang}},
            {"one" => {"foo" => "boo", "baz" => "jelly"}, :two => {"ying" => "yang", "zing" => :bananas}}
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => {"one" => {"foo" => "bar", "baz" => "jelly"}, :two => {"ying" => 1, "zing" => :zang}},
                :type => :hash,
                :size => 2
            },
            :second_element => {
                :value => {"one" => {"foo" => "boo", "baz" => "jelly"}, :two => {"ying" => "yang", "zing" => :bananas}},
                :type => :hash,
                :size => 2
            },
            :compare_type => :hash,
            :details => [
                ["one", {
                    :state => :unequal,
                    :first_element => {:value => {"foo" => "bar", "baz" => "jelly"}, :type => :hash, :size => 2},
                    :second_element => {:value =>  {"foo" => "boo", "baz" => "jelly"}, :type => :hash, :size => 2},
                    :compare_type => :hash,
                    :details => [
                        ["foo", {
                            :state => :unequal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "boo", :type => :string},
                            :compare_type => :string
                        }],
                        ["baz", {
                            :state => :equal,
                            :first_element => {:value => "jelly", :type => :string},
                            :second_element => {:value => "jelly", :type => :string},
                            :compare_type => :string
                        }]
                    ]
                }],
                [:two, {
                    :state => :unequal,
                    :first_element => {:value => {"ying" => 1, "zing" => :zang}, :type => :hash, :size => 2},
                    :second_element => {:value => {"ying" => "yang", "zing" => :bananas}, :type => :hash, :size => 2},
                    :compare_type => :hash,
                    :details => [
                        ["ying", {
                            :state => :unequal,
                            :first_element => {:value => 1, :type => :number},
                            :second_element => {:value => "yang", :type => :string},
                            :compare_type => nil
                        }],
                        ["zing", {
                            :state => :unequal,
                            :first_element => {:value => :zang, :type => :symbol},
                            :second_element => {:value => :bananas, :type => :symbol},
                            :compare_type => :symbol
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested hashes with differing elements" do
        actual = @asserter.assert_identical(
            {
                "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                "biz" => {:fiz => "gram", 1 => {2 => :sym}}
            },
            {
                "foo" => {1 => {"baz" => "crux", "foz" => {"fram" => "razzle"}}},
                "biz" => {:fiz => "graeme", 1 => 3}
            }
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => {
                    "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                    "biz" => {:fiz => "gram", 1 => {2 => :sym}}
                },
                :type => :hash,
                :size => 2
            },
            :second_element => {
                :value => {
                    "foo" => {1 => {"baz" => "crux", "foz" => {"fram" => "razzle"}}},
                    "biz" => {:fiz => "graeme", 1 => 3}
                },
                :type => :hash,
                :size => 2
            },
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :unequal,
                    :first_element => {
                        :value => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                        :type => :hash,
                        :size => 1
                    },
                    :second_element => {
                        :value => {1 => {"baz" => "crux", "foz" => {"fram" => "razzle"}}},
                        :type => :hash,
                        :size => 1
                    },
                    :compare_type => :hash,
                    :details => [
                        [1, {
                            :state => :unequal,
                            :first_element => {
                                :value => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}},
                                :type => :hash,
                                :size => 2
                            },
                            :second_element => {
                                :value => {"baz" => "crux", "foz" => {"fram" => "razzle"}},
                                :type => :hash,
                                :size => 2
                            },
                            :compare_type => :hash,
                            :details => [
                                ["baz", {
                                    :state => :unequal,
                                    :first_element => {:value => {"jelly" => 2}, :type => :hash, :size => 1},
                                    :second_element => {:value => "crux", :type => :string},
                                    :compare_type => nil
                                }],
                                ["foz", {
                                    :state => :unequal,
                                    :first_element => {:value => {"fram" => "frazzle"}, :type => :hash, :size => 1},
                                    :second_element => {:value => {"fram" => "razzle"}, :type => :hash, :size => 1},
                                    :compare_type => :hash,
                                    :details => [
                                        ["fram", {
                                            :state => :unequal,
                                            :first_element => {:value => "frazzle", :type => :string},
                                            :second_element => {:value => "razzle", :type => :string},
                                            :compare_type => :string
                                        }]
                                    ]
                                }]
                            ]
                        }]
                    ]
                }],
                ["biz", {
                    :state => :unequal,
                    :first_element => {:value => {:fiz => "gram", 1 => {2 => :sym}}, :type => :hash, :size => 2},
                    :second_element => {:value => {:fiz => "graeme", 1 => 3}, :type => :hash, :size => 2},
                    :compare_type => :hash,
                    :details => [
                        [:fiz, {
                            :state => :unequal,
                            :first_element => {:value => "gram", :type => :string},
                            :second_element => {:value => "graeme", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => {2 => :sym}, :type => :hash, :size => 1},
                            :second_element => {:value => 3, :type => :number},
                            :compare_type => nil
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify " hashes with surplus elements" do
        actual = @asserter.assert_identical(
            {"foo" => "bar"},
            {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => {"foo" => "bar"}, :type => :hash, :size => 1},
            :second_element => {:value => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}, :type => :hash, :size => 3},
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :equal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => :string
                }],
                ["baz", {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "jelly", :type => :string},
                    :compare_type => nil
                }],
                ["ying", {
                    :state => :surplus,
                    :first_element => nil,
                    :second_element => {:value => "yang", :type => :string},
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify " hashes with missing elements" do
        actual = @asserter.assert_identical(
            {"foo" => "bar", "baz" => "jelly", "ying" => "yang"},
            {"foo" => "bar"}
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}, :type => :hash, :size => 3},
            :second_element => {:value => {"foo" => "bar"}, :type => :hash, :size => 1},
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :equal,
                    :first_element => {:value => "bar", :type => :string},
                    :second_element => {:value => "bar", :type => :string},
                    :compare_type => :string
                }],
                ["baz", {
                    :state => :missing,
                    :first_element => {:value => "jelly", :type => :string},
                    :second_element => nil,
                    :compare_type => nil
                }],
                ["ying", {
                    :state => :missing,
                    :first_element => {:value => "yang", :type => :string},
                    :second_element => nil,
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested hashes with surplus elements" do
        actual = @asserter.assert_identical(
            {"one" => {"foo" => "bar"}},
            {"one" => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}}
        )
        expected = {
            :state => :unequal,
            :first_element => {:value => {"one" => {"foo" => "bar"}}, :type => :hash, :size => 1},
            :second_element => {:value => {"one" => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}}, :type => :hash, :size => 1},
            :compare_type => :hash,
            :details => [
                ["one", {
                    :state => :unequal,
                    :first_element => {:value => {"foo" => "bar"}, :type => :hash, :size => 1},
                    :second_element => {:value => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}, :type => :hash, :size => 3},
                    :compare_type => :hash,
                    :details => [
                        ["foo", {
                            :state => :equal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "bar", :type => :string},
                            :compare_type => :string
                        }],
                        ["baz", {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => "jelly", :type => :string},
                            :compare_type => nil
                        }],
                        ["ying", {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => "yang", :type => :string},
                            :compare_type => nil
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested hashes with missing elements" do
        actual = @asserter.assert_identical(
            {"one" => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}},
            {"one" => {"foo" => "bar"}}
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => {"one" => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"}},
                :type => :hash,
                :size => 1
            },
            :second_element => {
                :value => {"one" => {"foo" => "bar"}},
                :type => :hash,
                :size => 1
            },
            :compare_type => :hash,
            :details => [
                ["one", {
                    :state => :unequal,
                    :first_element => {
                        :value => {"foo" => "bar", "baz" => "jelly", "ying" => "yang"},
                        :type => :hash,
                        :size => 3
                    },
                    :second_element => {
                        :value => {"foo" => "bar"},
                        :type => :hash,
                        :size => 1
                    },
                    :compare_type => :hash,
                    :details => [
                        ["foo", {
                            :state => :equal,
                            :first_element => {:value => "bar", :type => :string},
                            :second_element => {:value => "bar", :type => :string},
                            :compare_type => :string
                        }],
                        ["baz", {
                            :state => :missing,
                            :first_element => {:value => "jelly", :type => :string},
                            :second_element => nil,
                            :compare_type => nil
                        }],
                        ["ying", {
                            :state => :missing,
                            :first_element => {:value => "yang", :type => :string},
                            :second_element => nil,
                            :compare_type => nil
                        }]
                    ]
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "nested hashes with variously differing hashes" do
        actual = @asserter.assert_identical(
            {
                "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                "biz" => {:fiz => "gram", 1 => {2 => :sym}},
                "bananas" => {:apple => 11}
            },
            {
                "foo" => {1 => {"foz" => {"fram" => "razzle"}}},
                "biz" => {42 => {:raz => "matazz"}, :fiz => "graeme", 1 => 3}
            }
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => {
                    "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                    "biz" => {:fiz => "gram", 1 => {2 => :sym}},
                    "bananas" => {:apple => 11}
                },
                :type => :hash,
                :size => 3
            },
            :second_element => {
                :value => {
                    "foo" => {1 => {"foz" => {"fram" => "razzle"}}},
                    "biz" => {42 => {:raz => "matazz"}, :fiz => "graeme", 1 => 3}
                },
                :type => :hash,
                :size => 2
            },
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :unequal,
                    :first_element => {
                        :value => {1 => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}}},
                        :type => :hash,
                        :size => 1
                    },
                    :second_element => {
                        :value => {1 => {"foz" => {"fram" => "razzle"}}},
                        :type => :hash,
                        :size => 1
                    },
                    :compare_type => :hash,
                    :details => [
                        [1, {
                            :state => :unequal,
                            :first_element => {
                                :value => {"baz" => {"jelly" => 2}, "foz" => {"fram" => "frazzle"}},
                                :type => :hash,
                                :size => 2
                            },
                            :second_element => {
                                :value => {"foz" => {"fram" => "razzle"}},
                                :type => :hash,
                                :size => 1
                            },
                            :compare_type => :hash,
                            :details => [
                                ["baz", {
                                    :state => :missing,
                                    :first_element => {:value => {"jelly" => 2}, :type => :hash, :size => 1},
                                    :second_element => nil,
                                    :compare_type => nil
                                }],
                                ["foz", {
                                    :state => :unequal,
                                    :first_element => {:value => {"fram" => "frazzle"}, :type => :hash, :size => 1},
                                    :second_element => {:value => {"fram" => "razzle"}, :type => :hash, :size => 1},
                                    :compare_type => :hash,
                                    :details => [
                                        ["fram", {
                                            :state => :unequal,
                                            :first_element => {:value => "frazzle", :type => :string},
                                            :second_element => {:value => "razzle", :type => :string},
                                            :compare_type => :string
                                        }]
                                    ]
                                }]
                            ]
                        }]
                    ]
                }],
                ["biz", {
                    :state => :unequal,
                    :first_element => {:value => {:fiz => "gram", 1 => {2 => :sym}}, :type => :hash, :size => 2},
                    :second_element => {:value => {42 => {:raz => "matazz"}, :fiz => "graeme", 1 => 3}, :type => :hash, :size => 3},
                    :compare_type => :hash,
                    :details => [
                        [:fiz, {
                            :state => :unequal,
                            :first_element => {:value => "gram", :type => :string},
                            :second_element => {:value => "graeme", :type => :string},
                            :compare_type => :string
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => {2 => :sym}, :type => :hash, :size => 1},
                            :second_element => {:value => 3, :type => :number},
                            :compare_type => nil
                        }],
                        [42, {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => {:raz => "matazz"}, :type => :hash, :size => 1},
                            :compare_type => nil
                        }]
                    ]
                }],
                ["bananas", {
                    :state => :missing,
                    :first_element => {:value => {:apple => 11}, :type => :hash, :size => 1},
                    :second_element => nil,
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end

      specify "arrays and hashes, mixed" do
        actual = @asserter.assert_identical(
            {
                "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => ["apple", "bananna", "orange"]}},
                "biz" => {:fiz => ["bing", "bong", "bam"], 1 => {2 => :sym}},
                "bananas" => {:apple => 11}
            },
            {
                "foo" => {1 => {"foz" => ["apple", "banana", "orange"]}},
                "biz" => {42 => {:raz => "matazz"}, :fiz => ["bang", "bong", "bam", "splat"], 1 => 3}
            }
        )
        expected = {
            :state => :unequal,
            :first_element => {
                :value => {
                    "foo" => {1 => {"baz" => {"jelly" => 2}, "foz" => ["apple", "bananna", "orange"]}},
                    "biz" => {:fiz => ["bing", "bong", "bam"], 1 => {2 => :sym}},
                    "bananas" => {:apple => 11}
                },
                :type => :hash,
                :size => 3
            },
            :second_element => {
                :value => {
                    "foo" => {1 => {"foz" => ["apple", "banana", "orange"]}},
                    "biz" => {42 => {:raz => "matazz"}, :fiz => ["bang", "bong", "bam", "splat"], 1 => 3}
                },
                :type => :hash,
                :size => 2
            },
            :compare_type => :hash,
            :details => [
                ["foo", {
                    :state => :unequal,
                    :first_element => {
                        :value => {1 => {"baz" => {"jelly" => 2}, "foz" => ["apple", "bananna", "orange"]}},
                        :type => :hash,
                        :size => 1
                    },
                    :second_element => {
                        :value => {1 => {"foz" => ["apple", "banana", "orange"]}},
                        :type => :hash,
                        :size => 1
                    },
                    :compare_type => :hash,
                    :details => [
                        [1, {
                            :state => :unequal,
                            :first_element => {
                                :value => {"baz" => {"jelly" => 2}, "foz" => ["apple", "bananna", "orange"]},
                                :type => :hash,
                                :size => 2
                            },
                            :second_element => {
                                :value => {"foz" => ["apple", "banana", "orange"]},
                                :type => :hash,
                                :size => 1
                            },
                            :compare_type => :hash,
                            :details => [
                                ["baz", {
                                    :state => :missing,
                                    :first_element => {:value => {"jelly" => 2}, :type => :hash, :size => 1},
                                    :second_element => nil,
                                    :compare_type => nil,
                                }],
                                ["foz", {
                                    :state => :unequal,
                                    :first_element => {:value => ["apple", "bananna", "orange"], :type => :array, :size => 3},
                                    :second_element => {:value => ["apple", "banana", "orange"], :type => :array, :size => 3},
                                    :compare_type => :array,
                                    :details => [
                                        [0, {
                                            :state => :equal,
                                            :first_element => {:value => "apple", :type => :string},
                                            :second_element => {:value => "apple", :type => :string},
                                            :compare_type => :string
                                        }],
                                        [1, {
                                            :state => :unequal,
                                            :first_element => {:value => "bananna", :type => :string},
                                            :second_element => {:value => "banana", :type => :string},
                                            :compare_type => :string
                                        }],
                                        [2, {
                                            :state => :equal,
                                            :first_element => {:value => "orange", :type => :string},
                                            :second_element => {:value => "orange", :type => :string},
                                            :compare_type => :string
                                        }]
                                    ]
                                }]
                            ]
                        }]
                    ]
                }],
                ["biz", {
                    :state => :unequal,
                    :first_element => {
                        :value => {:fiz => ["bing", "bong", "bam"], 1 => {2 => :sym}},
                        :type => :hash,
                        :size => 2
                    },
                    :second_element => {
                        :value => {42 => {:raz => "matazz"}, :fiz => ["bang", "bong", "bam", "splat"], 1 => 3},
                        :type => :hash,
                        :size => 3
                    },
                    :compare_type => :hash,
                    :details => [
                        [:fiz, {
                            :state => :unequal,
                            :first_element => {:value => ["bing", "bong", "bam"], :type => :array, :size => 3},
                            :second_element => {:value => ["bang", "bong", "bam", "splat"], :type => :array, :size => 4},
                            :compare_type => :array,
                            :details => [
                                [0, {
                                    :state => :unequal,
                                    :first_element => {:value => "bing", :type => :string},
                                    :second_element => {:value => "bang", :type => :string},
                                    :compare_type => :string
                                }],
                                [1, {
                                    :state => :equal,
                                    :first_element => {:value => "bong", :type => :string},
                                    :second_element => {:value => "bong", :type => :string},
                                    :compare_type => :string,
                                }],
                                [2, {
                                    :state => :equal,
                                    :first_element => {:value => "bam", :type => :string},
                                    :second_element => {:value => "bam", :type => :string},
                                    :compare_type => :string,
                                }],
                                [3, {
                                    :state => :surplus,
                                    :first_element => nil,
                                    :second_element => {:value => "splat", :type => :string},
                                    :compare_type => nil
                                }]
                            ]
                        }],
                        [1, {
                            :state => :unequal,
                            :first_element => {:value => {2 => :sym}, :type => :hash, :size => 1},
                            :second_element => {:value => 3, :type => :number},
                            :compare_type => nil
                        }],
                        [42, {
                            :state => :surplus,
                            :first_element => nil,
                            :second_element => {:value => {:raz => "matazz"}, :type => :hash, :size => 1},
                            :compare_type => nil
                        }]
                    ]
                }],
                ["bananas", {
                    :state => :missing,
                    :first_element => {:value => {:apple => 11}, :type => :hash, :size => 1},
                    :second_element => nil,
                    :compare_type => nil
                }]
            ]
        }
        assert(actual == expected)
      end
    end
  end
end
