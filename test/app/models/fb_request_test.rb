require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class FbRequestTest < Test::Unit::TestCase
  context "FbRequest Model" do
    should 'construct new instance' do
      @fb_request = FbRequest.new
      assert_not_nil @fb_request
    end
  end
end
