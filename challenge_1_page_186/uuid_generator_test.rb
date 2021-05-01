require 'test/unit/testcase'
require 'set'

require_relative 'uuid_generator'

class UUIDGeneratorTest < Test::Unit::TestCase
  CONCURRENT_USERS = 10
  ITERATIONS = 100

  false && def test_it_works
    generator = create_generator

    1.upto(10) do |expected_id|
      assert_equal expected_id, generator.generate
    end

    generator.stop
  end

  def test_concurrency
    generator = create_generator

    ITERATIONS.times do |i|
      generated_ids = Set.new

      expected_number_of_generated_ids = CONCURRENT_USERS

      min_id = i * CONCURRENT_USERS + 1
      max_id = (i+1) * CONCURRENT_USERS 
      expected_id_range = min_id..max_id

      threads = CONCURRENT_USERS.times.map do
        Thread.new do
          id = generator.generate
          generated_ids.add(id)
          Thread.current[:output] = id
        end
      end

      threads.map(&:join)

      assert(
        generated_ids.size == CONCURRENT_USERS,
        "Expected number of uniquely generated ids to equal #{expected_number_of_generated_ids}, but it was #{generated_ids.size}"
      )

      threads.each do |t|
        actual = t[:output]

        assert(
          expected_id_range === actual,
          "Expeceted ID #{actual} to be in range #{expected_id_range}"
        )
      end
    end

    generator.stop
  end

  private

  def create_generator
    UUIDGenerator.new
  end
end