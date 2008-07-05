require File.dirname(__FILE__) + '/../../vendor/lighthouse-api/lib/lighthouse'
require File.dirname(__FILE__) + '/../../vendor/grit/lib/grit'

Dir[File.dirname(__FILE__) + '/git_hooks/*.rb'].each do |file|
  require file
end
