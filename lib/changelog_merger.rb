require "changelog_merger/version"

module ChangelogMerger
  # Your code goes here...
  class Merger
    def initialize
    end

    def run_generator
      puts `github_changelog_generator`
    end
  end
end
