require 'guard'
require 'guard/guard'

module Guard
  class Strainer < Guard
    require 'strainer'
    require 'guard/strainer/runner'

    # Initialize guard-strainer.
    #
    # @param [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @param [Hash] options the custom Guard plugin options
    # @option options [Boolean] :standalone set to true for cookbook operation. Default false.
    # @option options [Boolean] :all_on_pass set to true to run all Strainerfiles on pass. Default true.
    # @option options [Boolean] :all_on_start set to true to run all Strainerfiles on start. Default true.
    # @option options [Boolean] :fail_fast set to true to fail immediately upon any non-zero exit code. Default true.
    # @option options [Array<String>] :except labels to ignore in the Strainerfiles
    # @option options [Array<String>] :only labels to include in the Strainerfiles
    # @option options [String] :cookbooks_path path to the cookbook store
    # @option options [String] :config path to the knife.rb/client.rb config
    # @option options [Boolean] :debug set to true to enable debugging log output. Default false.
    # @option options [Boolean] :color set to false to disable colored output. Default is true
    #
    def initialize(watchers = [], options = {})
      # Override the config file if it's specified
      ::Berkshelf::Chef::Config.path = options.delete(:config) if options[:config]

      # Set the Strainer path if it's specified
      ::Strainer.sandbox_path = options.delete(:sandbox) if options[:sandbox]

      # Use Strainer::Shell as the primary output shell
      ::Thor::Base.shell = ::Strainer::Shell

      # Set whether color output is enabled
      ::Thor::Base.shell.enable_colors = false unless options.delete(:color)

      # Use debugging output if asked
      $DEBUG = true if options.delete(:debug)

      super

      @options = {
        :standalone => false,
        :all_on_start => true,
        :all_on_pass => true,
        :fail_fast => true
      }.merge(options)

      @runner = Runner.new(@options)
    end

    def start
      UI.info "Guard::Strainer is running"
      run_all if @options[:all_on_start]
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      passed = @runner.run_all!

      throw :task_has_failed unless passed
    end

    # Common run definition used in run_on_additions,
    # run_on_modifications, and run_on_removals
    #
    # @param [Array<String>] paths to Strain
    # @raise [:task_has_failed] when run has failed
    # @return [Object] the task result
    def run(paths)
      passed = @runner.run!(paths)

      throw :task_has_failed unless passed
      @runner.run_all! if @options[:all_on_pass]
    end

    # Called on file(s) additions that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_additions has failed
    # @return [Object] the task result
    #
    def run_on_additions(paths)
      run(paths) 
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
      run(paths) 
    end

    # Called on file(s) removals that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_removals has failed
    # @return [Object] the task result
    #
    def run_on_removals(paths)
      run(paths) 
    end
  end
end
