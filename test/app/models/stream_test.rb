require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class StreamTest < Test::Unit::TestCase
  context "Stream Model" do
    should 'construct new instance' do
      @stream = Stream.new
      assert_not_nil @stream
    end
  end
end
