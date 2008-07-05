module Lighthouse::GitHooks
    
  class Configuration
    
    @@config = nil
    @@config_file_path = File.dirname(__FILE__) + '/config.yml'
    
    REQUIRED_KEYS = [:project_id, :account, :token, :repository_path]
    
    class << self
      def load(path=@@config_file_path)
        @@config = YAML.load_file(path).symbolize_keys
        check!
        run
        @@config
      end
      
      def [](key)
        @@config[key]
      end
      
      def run
        Lighthouse.account = @@config[:account]
        Lighthouse.token = @@config[:token]
      end
      
      protected
      
      def check!
        missing = REQUIRED_KEYS - @@config.keys
        raise "missing configuration params : #{missing.join(',')}" unless missing.empty?
      end
    end # << self
     
  end # Configuration

end