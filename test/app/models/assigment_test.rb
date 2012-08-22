require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class AssigmentTest < Test::Unit::TestCase
  context "Assigment Model" do
    should 'construct new instance' do
      @assigment = Assigment.new
      assert_not_nil @assigment
    end
  end
end
