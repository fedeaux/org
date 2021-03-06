module Api
  module V1
    class LogsController < BaseController
      before_action :set_log, only: [:update, :destroy]

      def create
        @log = Log.create log_params
        render :show
      end

      def update
        @log.update log_params
        render :show
      end

      def destroy
        @log.destroy
        render :show
      end

      def index
        if params[:date]
          @logs = Log.on_day(datetime_param)
        elsif params[:loggable_id]
          @logs = Log.by_loggable_id(params[:loggable_id]).order 'start'
        end
      end

      def datetime_param
        return DateTime.strptime(params[:date], '%Y-%m-%dT%H:%M:%S%z') if params[:date]
        DateTime.now.beginning_of_day
      end

      def set_log
        @log = Log.find params[:id]
      end

      def log_params
        params.require(:log).permit(:id, :loggable_id, :start, :finish, :description)
      end
    end
  end
end
