#! /usr/bin/env ruby
require File.dirname(__FILE__) + "/../lib/lighthouse/git_hooks"
include Lighthouse::GitHooks

Configuration.load(File.dirname(__FILE__) + "/../config.yml")
TicketUpdate.new(ARGV[0], ARGV[1]).parse.send_changes
