##
# Example of the UnitTest. More can be found here:
# https://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing

require "test/unit"
 
class TestSimpleNumber < Test::Unit::TestCase
 

  def setup
    # SetUp
  end

  def teardown
    # TearDown
  end

  def test_simple
    assert_equal(4, 4)
    assert_equal(6, 6)
  end
 
end
