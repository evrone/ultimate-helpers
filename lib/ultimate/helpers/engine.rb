module Ultimate
  module Helpers
    class Engine < ::Rails::Engine
      isolate_namespace Ultimate::Helpers
    end
  end
end
