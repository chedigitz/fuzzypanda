require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class CrewmemberTest < Test::Unit::TestCase
  context "Crewmember Model" do
    should 'construct new instance' do
      @crewmember = Crewmember.new
      assert_not_nil @crewmember
    end
  end
end
