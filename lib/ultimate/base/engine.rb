module Ultimate
  module Base
    class Engine < ::Rails::Engine
      isolate_namespace Ultimate::Base
    end
  end
end
