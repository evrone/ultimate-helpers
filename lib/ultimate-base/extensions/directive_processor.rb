require 'sprockets'

module Ultimate
  module Extensions
    module DirectiveProcessor
      extend ActiveSupport::Concern

      module InstanceMethods

        def process_require_all_directive(path)
          raise ArgumentError, "require_all argument must be a relative path" unless relative?(path)

          context.environment.paths.each do |root_path|
            root = Pathname.new(root_path).join(path).expand_path

            if root.exist? && root.directory?
              context.depend_on(root)

              #Dir["#{root}/*"].sort.each do |filename|
              entries(root).each do |pathname|
                filename = root.join(pathname)
                if filename == self.file
                  next
                elsif context.asset_requirable?(filename)
                  context.require_asset(filename)
                end
              end
            end
          end
        end

        # `require_first` requires all the files
        # inside a first counter single directory.
        #
        #     //= require_first "./ultimate/undercore"
        #
        def process_require_first_directive(path)
          raise ArgumentError, "require_first argument must be a relative path" unless relative?(path)

          context.environment.paths.each do |root_path|
            root = Pathname.new(root_path).join(path).expand_path

            if root.exist? && root.directory?
              context.depend_on(root)
              Rails.logger.info('----------')
              Rails.logger.info(root)
              Dir["#{root}/*"].sort.each do |filename|
                if filename == self.file
                  next
                elsif context.asset_requirable?(filename)
                  context.require_asset(filename)
                end
              end

              break

            end
          end
        end

      end

    end
  end
end

Sprockets::DirectiveProcessor.send :include, Ultimate::Extensions::DirectiveProcessor
