#!/usr/bin/env ruby
require 'optparse'
require 'pp'
require_relative 'version'

module ChangelogMerger
  class Parser
    def self.parse_options
      # :include_labels => %w(bug enhancement),

      options = {}

      parser = OptionParser.new { |opts|
        opts.banner = 'Usage: changelog_merger [options]'
        opts.on('-r', '--repo REPO', 'destination repo in format user/repo') do |last|
          options[:repo] = last
        end
        opts.on('-t', '--token [TOKEN]', 'To make more than 50 requests per hour your GitHub token required. You can generate it here: https://github.com/settings/tokens/new') do |last|
          options[:token] = last
        end
        opts.on('-m', '--message [MESSAGE]', 'Message for pull request') do |last|
          options[:message] = last
        end
        options[:verbose] = true
        opts.on('--[no-]verbose', 'Run verbosely. Default is true') do |v|
          options[:verbose] = v
        end
        opts.on('-v', '--version', 'Print version number') do |v|
          puts "Version: #{ChangelogMerger::VERSION}"
          exit
        end
        options[:path] = `echo ~`.strip!
        opts.on('-p', '--path', 'Path to save projects') do |v|
          options[:path] = v
        end
        opts.on('-h', '--help', 'Displays Help') do
          puts opts
          exit
        end
      }

      begin
        parser.parse!

        mandatory = [:repo] # Enforce the presence of
        missing = mandatory.select { |param| options[param].nil? } # the -t and -f switches
        unless missing.empty?
          puts "Missing options: #{missing.join(', ')}"
          puts parser
          exit
        end

        if options[:repo]
          options[:user], options[:project] = options[:repo].split('/')
        end

        if !options[:user] || !options[:project]
          puts parser.banner
          exit
        end

      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $!.to_s # Friendly output when parsing fails
        puts parser
        exit
      end

      if options[:verbose]
        puts 'Performing task with options:'
        pp options
        puts ''
      end

      options
    end
  end
end
