require File.dirname(__FILE__) + '/spec_helper.rb'

describe Configuration do
  
  def stub_config_load(params) 
    YAML.should_receive(:load_file).and_return(params)
    Configuration.stub!(:load_users)
  end
  
  it "load general configuration" do
    hash = nil
    lambda do
      hash = Configuration.load(File.dirname(__FILE__) + '/config_test')
    end.should_not raise_error
    
    hash.should be_instance_of(Hash)
  end
  
  it "raise if no account" do
    stub_config_load({
      'project_id' => 112389,
      'repository_path' => '/Users/gwik/dev/hlf2.git'
    })
    
    lambda do
      hash = Configuration.load(File.dirname(__FILE__) + '/config_test')
    end.should raise_error
    
  end
  
  it "raise if no project_id" do
    stub_config_load({
      'account' => 'gwikzone',
      'repository_path' => '/Users/gwik/dev/hlf2.git'
    })
    
    lambda do
      hash = Configuration.load(File.dirname(__FILE__) + '/config_test')
    end.should raise_error
    
  end
  
  it "raise if no repository path" do
    stub_config_load({
      'project_id' => 112389,
      'account' => 'gwikzone',
    })
    
    lambda do
      hash = Configuration.load(File.dirname(__FILE__) + '/config_test')
    end.should raise_error
    
  end
  
  it "should have default value for :include_diffs set to true" do
    Configuration.load(File.dirname(__FILE__) + '/config_test')
    Configuration[:include_diffs].should be_true
  end
  
  it "allow access to params through []" do
    Configuration.load(File.dirname(__FILE__) + '/config_test')
    
    Configuration[:account].should == 'gwikzone'
  end
  
  it "load users" do
    Configuration.load(File.dirname(__FILE__) + '/config_test')
    
    Configuration.users.should be_instance_of(Hash)
    Configuration.users.keys.should == [:joe, :gwik]
  end
  
  it "load users configuration" do
    Configuration.load(File.dirname(__FILE__) + '/config_test')
    Configuration.users[:gwik].should be_instance_of(Hash)
    Configuration.users[:joe].keys.size.should == 3 
  end
  
  it "logs in to lighthouse with token" do
    Configuration.load(File.dirname(__FILE__) + '/config_test')
    
    gwik = Configuration.users[:gwik]
    
    lambda do
      user = Configuration.login('gwik@gwikzone.org')
      user.should be(gwik)
      Lighthouse.account.should == Configuration[:account]
      Lighthouse.token.should == gwik[:token]
    end.should_not raise_error
    
  end
  
end