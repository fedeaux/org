module Api
  module V1
    class LoggablesController < BaseController
      def index
        @loggables = current_user.loggables.roots
      end
    end
  end
end
