class ExamplesController < ApplicationController
  layout 'example'

  def show
    render "examples/#{params[:example]}"
  end
end
