# frozen_string_literal: true

module Decidim
  #
  # Decorator for assembly members
  #
  class AssemblyMemberPresenter < SimpleDelegator
    def gender
      I18n.t(__getobj__.gender, scope: "decidim.admin.models.assembly_member.genders", default: "-")
    end

    def name
      name = __getobj__.full_name

      if (user = __getobj__.user.presence)
        name << " (#{Decidim::UserPresenter.new(user).nickname})"
      end

      name
    end

    def position
      return __getobj__.position_other if __getobj__.position == "other"

      I18n.t(__getobj__.position, scope: "decidim.admin.models.assembly_member.positions", default: "-")
    end
  end
end
