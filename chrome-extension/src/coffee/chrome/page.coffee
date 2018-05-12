# Warning: This file is used for development only.
# In a production environment, page.js will be a copy of /api/v1/bundles/page.js

# See "gulp release" for more information

base_url = 'http://localhost:3000'
js_api_url = "#{base_url}/api/v1/bundles/page.js?js_bundle_environment=chrome_extension"

$.ajax
  url: js_api_url
  complete: (response) =>
    eval response.responseText
