require File.dirname(__FILE__) + '/spec_helper.rb'

describe TicketUpdate do
  
  describe "build_message method"  do
    
    before(:each) do
      Grit::Commit.stub!(:find_all).and_return([])
      Grit::Repo.stub!(:new).and_return(nil)
      Configuration.load(File.dirname(__FILE__) + '/config_test')
      @ticket_updater = Lighthouse::GitHooks::TicketUpdate.new(1,2)
      @diff = stub("diff", :diff=>"My lovely diff")
      @commit = stub("commit", :diffs=>[@diff], :message=>"My commit message", :id=>1)
    end
    
    it "should include diffs when Configuration[:include_diffs] is true" do
      @ticket_updater.send(:build_message, @commit).should =~ /My lovely diff/
    end
    
    it "should not include diffs when Configuration[:include_diffs] is false" do
      Configuration.stub!(:[]).with(:include_diffs).and_return(false)
      @ticket_updater.send(:build_message, @commit).should_not =~ /My lovely diff/
    end
    
    it "should not include diffs when diffs are empty" do
      @commit.stub!(:diffs).and_return([])
      @ticket_updater.send(:build_message, @commit).should_not =~ /@@@\n.*?\n@@@/
    end
    
  end
  
  it "should have spec"
  
end