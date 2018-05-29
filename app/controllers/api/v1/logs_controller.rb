module Api
  module V1
    class LogsController < BaseController
      def create
        @log = Log.create log_params
      end

      def index
        @logs = Log.on_day(datetime_param) if params[:date]
      end

      def datetime_param
        return DateTime.strptime(params[:date], '%Y-%m-%dT%H:%M:%S%z') if params[:date]
        DateTime.now.beginning_of_day
      end

      def log_params
        params.require(:log).permit(:id, :loggable_id, :start, :finish, :description)
      end
    end
  end
end
