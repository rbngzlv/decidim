# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to create managed users from the admin dashboard.
    #
    class ManagedUserForm < Form
      attribute :name, String

      validates :name, presence: true
      validate :authorization_uniqueness

      def initialize(attributes)
        extend(Virtus.model)

        # Set the authorization dynamic attribute as a nested form class based on the handler name.
        attribute(:authorization, Decidim::AuthorizationHandler.handler_for(attributes.dig(:authorization, :handler_name)))

        super
      end

      private

      def authorization_uniqueness
        errors.add :authorization, :invalid if Authorization.where(
          user: current_organization.users,
          name: authorization.handler_name,
          unique_id: authorization.unique_id
        ).exists?
      end
    end
  end
end
