#! /usr/bin/env ruby

####### EDIT ME !!!! ######
CONFIG_DIR = "/Users/gwik/dev/lighthouse-git-hooks/config"
LIB_DIR = "/Users/gwik/dev/lighthouse-git-hooks" 
###########################

require LIB_DIR + "/lib/lighthouse/git_hooks"
include Lighthouse::GitHooks

rev_old, rev_new, ref = STDIN.read.split(" ")

Configuration.load(CONFIG_DIR)
TicketUpdate.new(rev_old, rev_new).parse.send_changes
