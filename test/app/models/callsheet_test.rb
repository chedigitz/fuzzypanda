require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class CallsheetTest < Test::Unit::TestCase
  context "Callsheet Model" do
    should 'construct new instance' do
      @callsheet = Callsheet.new
      assert_not_nil @callsheet
    end
  end
end
