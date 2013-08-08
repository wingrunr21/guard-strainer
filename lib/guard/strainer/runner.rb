module Guard
  class Strainer
    class Runner
      attr_reader :cabinet

      def initialize(options)
        @options = options
        @cabinet = {}
      end

      def run!(paths = [])
        cookbooks = paths.map{|path| find_cookbook_name(path)}
        runner = runner_for_cookbooks(cookbooks)

        UI.info "Straining: #{cookbooks.join(',')}"
        runner.run!
      end

      def run_all!
        paths = Dir[File.join('**', 'metadata.rb')]
        run!(paths)
      end

      protected
      def find_cookbook_name(path)
        current_path = Pathname.new(File.dirname(path))
        cookbook = nil

        until current_path == ::Guard::Dsl.options["guardfile_path"] do
          if File.exist?(File.join(current_path, 'metadata.rb'))
            cookbook = current_path.basename
            break
          else
            current_path = current_path.parent
          end
        end

        cookbook
      end

      def runner_for_cookbooks(cookbooks)
        @cabinet.fetch(cookbooks) do |books|
          ::Strainer::Runner.new(books, @options.merge({strainer_file: File.join(File.dirname(::Guard::Dsl.options["guardfile_path"]), ::Strainer::Strainerfile::DEFAULT_FILENAME)}))
        end
      end
    end
  end
end
