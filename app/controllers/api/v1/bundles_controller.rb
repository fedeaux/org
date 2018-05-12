module Api
  module V1
    class BundlesController < Api::V1::BaseController
      def index
        @js_files = ['application']
        @css_files = ['application']
      end

      def page
        set_js_bundle_environment
        @js_files = ['application']
      end

      def theme
        @css_files = ['application']
      end

      def set_js_bundle_environment
        # In the future, use standalone.options.skip_initialization
        @js_bundle_environment = js_bundle_environments[js_bundle_environment_name]
      end

      private

      def js_bundle_environment_name
        ['chrome_extension', 'standalone'].include?(params['js_bundle_environment']) ? params['js_bundle_environment'].to_sym : :standalone
      end

      def js_bundle_environments
        # TODO use real classes instead of OpenStruct
        {
          chrome_extension: OpenStruct.new(
            name: 'chrome_extension',
            asset_name: 'chrome_extension.js',
            constructor: 'ChromeExtension',
            condition: get_chrome_extension_condition,
            options: {}),

          standalone: OpenStruct.new(
            name: 'standalone',
            asset_name: 'standalone.js',
            constructor: 'Standalone',
            condition: get_standalone_condition,
            options: {}
          ),
        }
      end

      def get_standalone_condition
        # return 'true' if params['force'] # for the future, maybe
        '!document.documentElement.getAttribute("data-tatapp-extension-installed")'
      end

      def get_chrome_extension_condition
        # 'typeof(Global) == "undefined"' # for the future, maybe
        'true'
      end
    end
  end
end
