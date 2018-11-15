class BoardPolicy < ApplicationPolicy
  permit_only_admin_to :update, :destroy, :create
end
