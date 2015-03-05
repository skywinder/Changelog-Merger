require "changelog_merger/version"

require_relative "changelog_merger/parser"

module ChangelogMerger
  # Your code goes here...
  class Merger
    def initialize
      @options = Parser.parse_options

    end

    def run_generator
      go_to_work_dir
      # puts `github_changelog_generator #{@options[:repo]}`
    end

    def go_to_work_dir
      Dir.chdir(@options[:path])

      merger_folder = 'changelog_merger'
      unless Dir.exist?(merger_folder)
        puts "Creating directory #{merger_folder}"
        Dir.mkdir(merger_folder)
      end
      Dir.chdir("./#{merger_folder}")

      puts "Go to #{Dir.pwd}"
    end
  end
end

if __FILE__ == $0
  ChangelogMerger::Merger.new.run_generator
end
