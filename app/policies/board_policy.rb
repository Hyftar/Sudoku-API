class BoardPolicy < ApplicationPolicy
  permit_only_admin_to :index, :update, :destroy, :create
end
