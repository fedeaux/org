module Api
  module V1
    class CallbacksController < Api::V1::BaseController
      def register_uninstall_data
        endpoint = 'http://www.google-analytics.com/collect'

        query = {
          v: 1,
          tid: ENV['GA_TRACKER_CODE'],
          uid: params[:user_id],
          ec: 'TatApp::Uninstall',
          ea: { user_id: params[:user_id] }.to_json,
          t: "event",
        }

        HTTParty.get endpoint, query: query
      end

      def uninstall
        register_uninstall_data
        respond_after_uninstall
      end

      def respond_after_uninstall
        if ENV['UNINSTALL_FORM_URL']
          redirect_to ENV['UNINSTALL_FORM_URL']
          return
        end

        head :ok
      end
    end
  end
end
