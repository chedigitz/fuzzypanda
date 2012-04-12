require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class StreamhubTest < Test::Unit::TestCase
  context "Streamhub Model" do
    should 'construct new instance' do
      @streamhub = Streamhub.new
      assert_not_nil @streamhub
    end
  end
end
