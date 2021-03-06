class ApplicationController < ActionController::API
  require 'json_web_token'
  include Response
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render(json: { error: 'unauthorized' }, status: 401) unless @current_user
  end
end
