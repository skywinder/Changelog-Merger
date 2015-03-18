#!/usr/bin/env ruby
require 'optparse'
require 'pp'
require_relative 'version'

module ChangelogMerger
  class Parser
    def self.parse_options
      # :include_labels => %w(bug enhancement),

      options = {:message => 'Added automatically generated change log file',
                :output => 'CHANGELOG.md'
                 # :dry_run => true
      }

      parser = OptionParser.new { |opts|
        opts.banner = 'Usage: changelog_merger [options]'
        opts.on('-r', '--repo [REPO]', 'destination repo in format user/repo') do |last|
          options[:repo] = last
        end
        opts.on('-d', '--dry-run', 'dry run') do |last|
          options[:dry_run] = last
        end
        opts.on('-x', 'just generate log and open it') do |last|
          options[:run_wo_pr] = last
        end
        opts.on('-o', '--output [NAME]', 'Output file. Default is CHANGELOG.md') do |last|
          options[:output] = last
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

        if ARGV.count == 1
          options[:repo] = ARGV[0]
        end

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

      options[:pr_message] =  "Add automatically generated change log file.

Hi, as I can see, you are carefully fill tags and labels for issues in your repo.

And special for such cases - I created a [github_changelog_generator](https://github.com/skywinder/github-changelog-generator), that generate change log file based on **tags**, **issues** and merged **pull requests** (and split them to separate lists according labels) from :octocat: GitHub Issue Tracker.

By using this script your Change Log will look like this: [Click me!](https://github.com/skywinder/#{options[:project]}/blob/add-change-log-file/#{options[:output]})

***What’s the point of a change log?***
To make it easier for users and contributors to see precisely what notable changes have been made between each release (or version) of the project.

And now you don't need to spend a lot of :hourglass_flowing_sand: for filling it manually!

Some essential features of **github_changelog_generator**:

- Generate **neat** Change Log file according basic [change log guidelines](http://keepachangelog.com). :gem:
- **Distinguish** issues and split according labels:
    - Merged pull-requests (all `merged` pull-requests)
    - Bug-fixes (by label `bug` in issue)
    - Enhancements (by label `enhancement` in issue)
    - 	Issues (closed issues w/o any labels)
-  it **exclude** not-related to changelog issues (any issue, that has label `question` `duplicate` `invalid` `wontfix` )  :scissors:

- You can set which labels should be included/excluded and apply a lot of other customisations, to fit changelog for your personal style :tophat: (*look `github_changelog_generator --help`  for details)*

You can easily update this file in future by simply run script: `github_changelog_generator #{options[:repo]}` in your repo folder and it make your Change Log file up-to-date again!

So, since now you don't have to fill your CHANGELOG.md manually: just run script, relax and take a cup of :coffee: before your next release!

Hope you find this commit as useful. :wink:"

      if options[:verbose]
        puts 'Performing task with options:'
        pp options
        puts ''
      end

      options
    end
  end
end
