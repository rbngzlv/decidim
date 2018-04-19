# frozen_string_literal: true

module Decidim
  module Admin
    #
    # Decorator for assembly members
    #
    class AssemblyMemberPresenter < SimpleDelegator
      def name
        if user
          "#{user.name} (#{Decidim::UserPresenter.new(user).nickname})"
        else
          full_name
        end
      end
    end
  end
end
