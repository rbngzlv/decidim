# frozen_string_literal: true

require_dependency "decidim/admin/application_controller"

module Decidim
  module Admin
    module ManagedUsers
      # Controller that allows impersonating managed users at the admin panel.
      #
      class ImpersonationsController < Admin::ApplicationController
        helper Decidim::AuthorizationFormHelper

        layout "decidim/admin/users"

        skip_authorization_check only: [:index, :close_session]

        def index
          @impersonation_logs = Decidim::ImpersonationLog.where(user: user).order(started_at: :desc).page(params[:page]).per(15)
        end

        def new
          authorize! :impersonate, user

          @form = Decidim::AuthorizationHandler.handler_for(user.managed_with)
        end

        def create
          authorize! :impersonate, user

          @form = Decidim::AuthorizationHandler.handler_for(user.managed_with, handler_params)

          ImpersonateManagedUser.call(@form, user, current_user) do
            on(:ok) do
              redirect_to decidim.root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("managed_users.impersonate.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def close_session
          CloseSessionManagedUser.call(user, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("managed_users.close_session.success", scope: "decidim.admin")
              redirect_to managed_users_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("managed_users.close_session.error", scope: "decidim.admin")
              redirect_to decidim.root_path
            end
          end
        end

        private

        def handler_params
          params[:authorization_handler].merge(user: user)
        end

        def user
          @user ||= current_organization.users.managed.find(params[:managed_user_id])
        end
      end
    end
  end
end
