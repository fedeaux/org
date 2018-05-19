module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :force_current_user

      def force_current_user
        sign_in(:user, User.first)
      end
    end
  end
end
