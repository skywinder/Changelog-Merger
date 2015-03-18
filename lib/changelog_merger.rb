require "changelog_merger/version"

require_relative "changelog_merger/parser"

module ChangelogMerger
  # Your code goes here...
  class Merger
    def initialize
      @options = Parser.parse_options

    end

    def run_generator
      if @options[:run_wo_pr]
        generate_change_log
        execute_line("open #{@options[:output]}")
      else
        go_to_work_dir
        clone_repo_and_cd
        generate_change_log
        add_commit_push
      end
    end

    def add_commit_push
      execute_line('hub fork')
      execute_line('git checkout -b add-change-log-file')
      execute_line("git add #{@options[:output]}")
      execute_line("git commit -v -m '#{@options[:message]}'")
      execute_line('git push skywinder')
      # execute_line('git push')
      execute_line("hub pull-request -m '#{@options[:pr_message]}' -o")
    end

    def generate_change_log
      execute_line("github_changelog_generator #{@options[:repo]} -o #{@options[:output]}")
    end

    def clone_repo_and_cd
      if Dir.exist?(@options[:project])
        execute_line("rm -rf #{@options[:project]}")
      end
      execute_line("hub clone #{@options[:repo]}")
      Dir.chdir("./#{@options[:project]}")
      puts "Go to #{Dir.pwd}"
    end

    def execute_line(line)
      if @options[:dry_run]
        puts "Dry run: #{line}"
        return nil
      end
      puts line
      value = %x[#{line}]
      puts value
      check_exit_status(value)
      value
    end

    def check_exit_status(output)
      if $?.exitstatus != 0
        puts "Output:\n#{output}\nExit status = #{$?.exitstatus} ->Terminate script."
        exit
      end
    end

    def go_to_work_dir
      Dir.chdir(@options[:path])

      merger_folder = 'changelog_merger_dir'
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
