# frozen_string_literal: true

class RemoveManagedUserAuthorizations < ActiveRecord::Migration[5.1]
  class User < ApplicationRecord
    self.table_name = :decidim_users
  end

  class Authorization < ApplicationRecord
    self.table_name = :decidim_authorizations
  end

  def up
    add_column :decidim_users, :managed_with, :string

    User.where(managed: true).find_each do |user|
      user_authorizations = Authorization.where(decidim_user_id: user.id)

      user.update!(managed_with: user_authorizations.last.name)
      user_authorizations.destroy_all
    end

    remove_column :decidim_users, :managed
  end

  def down
    add_column :decidim_users, :managed, :boolean, null: false, default: false

    remove_column :decidim_users, :managed_with, :string
  end
end
