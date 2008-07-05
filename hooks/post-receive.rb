#! /usr/bin/env ruby

####### EDIT ME !!!! ######
CONFIG_DIR = "/Users/gwik/dev/lighthouse-git-hooks/config"
LIB_DIR = "/Users/gwik/dev/lighthouse-git-hooks" 
###########################

require LIB_DIR + "/lib/lighthouse/git_hooks"
include Lighthouse::GitHooks

Configuration.load(CONFIG_DIR)
TicketUpdate.new(ARGV[0], ARGV[1]).parse.send_changes
