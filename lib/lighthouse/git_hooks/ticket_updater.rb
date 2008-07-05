require 'fileutils'
module Lighthouse::GitHooks
    
  class Base
    
    def initialize
      @repo = Grit::Repo.new(Configuration[:repository_path])
    end
    
  end # Base

  class TicketUpdate < Base

    attr_accessor :message
    attr_reader :tickets
    attr_reader :real_tickets

    AUTHORIZED_KEYS = [ 'assign', 'state', 'tags', 'untag']

    def initialize(old_rev, new_rev)
      super()
      @commits = @repo.commits_between(old_rev, new_rev)
      @message = ""
      @changes = []
    end
    
    def parse
      @commits.each do |commit|
        commit.message.scan(/\[#([0-9]+)\s+(.*?)\]/) do |match|
          @changes << parse_ticket(commit, match[0], match[1])
        end
      end
      self
    end
    
    def send_changes
      
      @changes.each do |hash_ticket|
        commit = hash_ticket.delete 'commit'
        
        Configuration.login(commit.committer.email)
        
        begin
          puts "updating ticket ##{hash_ticket['number']}"
          ticket = Lighthouse::Ticket.find(hash_ticket['number'], :params => {:project_id => Configuration[:project_id]})

          hash_ticket.each_pair do |key, value|
            case key
            when 'number'
              # do nothing
            when 'assign'
              if user_id = find_user(value.strip)
                ticket.assigned_user_id = user_id
              end
            when 'tags'
              ticket.tags = (ticket.tags + value.split(' ')).uniq
              puts "tags: #{ticket.tags.inspect}"
            when 'untag'
              ticket.tags.delete value
            else
              ticket.send "#{key}=".to_sym, value 
            end
          end
          ticket.body = message
          ticket.save
        rescue ActiveResource::ResourceNotFound => e
          puts "ticket not found ##{hash_ticket['number']} : #{e.message}"
          next
        end
      end
    end

    protected

    def parse_ticket(commit, number, params)
      ticket = {'number' => number.to_i, 'commit' => commit}
      params.scan(/(\w+):(\w+|'.*?')/) do |key, value|
        ticket[key] = value.gsub(/^["'](.*)["']$/, '\1') if AUTHORIZED_KEYS.include?(key)
      end
      ticket
    end
    
    def find_user(nick)
      user = Configuration.users[nick.to_sym]
      raise "user not found #{nick}" unless user
      user.id
    end
    
  end
  
end