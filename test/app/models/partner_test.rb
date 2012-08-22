require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class PartnerTest < Test::Unit::TestCase
  context "Partner Model" do
    should 'construct new instance' do
      @partner = Partner.new
      assert_not_nil @partner
    end
  end
end
