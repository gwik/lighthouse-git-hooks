require 'yaml'

module Lighthouse::GitHooks
    
  class Configuration
    
    @@config = nil
    @@users = nil
    
    REQUIRED_KEYS = [:project_id, :account, :repository_path]
    
    class << self
      def load(config_path)
        @@config = YAML.load_file(config_path + '/general.yml').symbolize_keys
        load_users(config_path + '/users')
        check!
        @@config
      end
      
      def [](key)
        @@config[key]
      end
      
      def users
        @@users
      end
      
      def login(git_user_email)
        nick, user = @@users.find{|k,v| v[:email] == git_user_email}
        raise "user not found #{git_user_email}" if user.nil?
        Lighthouse.account = @@config[:account]
        Lighthouse.token = user[:token]
        user
      end
      
      protected
      
      def load_users(dir)
        @@users = {}
        Dir.open(dir).entries.grep(/\.yml$/) do |entry|
          @@users[entry[/^(.*)\.yml$/, 1].to_sym] = YAML.load_file(dir + '/' + entry).symbolize_keys
        end
        @@users
      end
      
      def check!
        missing = REQUIRED_KEYS - @@config.keys
        raise "missing configuration params : #{missing.join(',')}" unless missing.empty?
      end
    end # << self
     
  end # Configuration

end