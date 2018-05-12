module Api
  module V1
    class TatsController < Api::V1::BaseController
      before_action :set_tat, only: [:update, :destroy]

      def index
        @user = User.ensure_temporary(params[:user_id])
        @tats = Tat.by_target target_params
      end

      def create
        @tat = Tat.new tat_params

        if @tat.save
          render status: :created
        else
          render status: :unprocessable_entity
        end
      end

      def update
        # TODO: This is very insecure
        if @tat.update tat_params
          render status: :ok
        else
          render status: :unprocessable_entity
        end
      end

      def destroy
        if @tat.destroy
          head :no_content, status: :ok
        else
          head :no_content, status: :forbidden
        end
      end

      private

      def set_tat
        @tat = Tat.find params[:id]
      end

      def tat_params
        params.require(:tat).permit(:id, :user_id,
          contents_attributes: [:id, :content, :content_type,
            properties: {
              normalized: [:top, :left, :'font-size'],
              css: [:'background-color', :color ],
              transformations: [:rotate]
            }
          ],
          target_attributes: [:id, :start, :duration, :type, :identifier]
        )
      end

      def target_params
        params.require(:target).permit(:type, :identifier)
      end
    end
  end
end
