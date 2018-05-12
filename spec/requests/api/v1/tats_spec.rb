require 'rails_helper'

describe 'Tats requests', type: :request do
  let(:new_tat_params) do
    {
      tat: {
        contents_attributes: {
          "0" => {
            content: "Tat.me is nice :)",
            content_type: "text",
            properties: {
              normalized: {
                top: "0.008911017706805024",
                left: "0.16433583613588165",
                'font-size': "0.04117938169189356"
              },
              css: {
                'background-color': "#7e584c",
                color: "#81a7b3"
              }
            }
          }
        },
        target_attributes: {
          start: "0",
          duration: "3",
          type: "TatTargetYoutubeVideo",
          identifier: "SlZu8wakdMQ"
        }
      }
    }
  end

  describe 'POST /api/v1/tats.json' do
    it 'creates a new tat' do
      expect do
        post api_v1_tats_path(format: :json), params: new_tat_params
      end.to change { Tat.count }.by 1

      expect(response).to be_created
    end
  end

  describe 'GET /api/v1/tats.json' do
    it 'creates a new user if no user_id parameter is set' do
      expect do
        get api_v1_tats_path(format: :json), params: { target: { type: 'TYPE', identifier: 'aYujm7yu18i' } }
      end.to change { User.count }.by 1
    end

    it 'does not create a new user if user_id parameter is set' do
      expect do
        get api_v1_tats_path(format: :json), params: {
          target: {
            type: 'TYPE', identifier: 'aYujm7yu18i'
          },
          user_id: 123
        }

      end.to change { User.count }.by 0
    end
  end
end
