require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class EventTest < Test::Unit::TestCase
  context "Event Model" do
    should 'construct new instance' do
      @event = Event.new
      assert_not_nil @event
    end
  end
end
