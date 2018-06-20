class ApplicationController < ActionController::API
  include Response
  include Pundit

  before_action :authenticate_request
  attr_reader :current_user

  def self.permit_only_admin_to(*actions)
    actions.each do |action|
      define_method("#{action}?") do
        @current_user.admin?
      end
    end
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render(json: { error: 'unauthorized' }, status: 401) unless @current_user
  end
end
