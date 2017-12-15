# frozen_string_literal: true

class RemoveManagedUserAuthorizations < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    self.table_name = :decidim_users
  end

  class Authorization < ApplicationRecord
    self.table_name = :decidim_authorizations
  end

  def up
    User.where(managed: true).find_each do |user|
      Authorization.where(decidim_user_id: user.id).destroy_all
    end
  end

  def down
  end
end
