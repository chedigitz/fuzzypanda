require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class VenueTest < Test::Unit::TestCase
  context "Venue Model" do
    should 'construct new instance' do
      @venue = Venue.new
      assert_not_nil @venue
    end
  end
end
