# frozen_string_literal: true

require "spec_helper"
require "decidim/admin/test/forms/attachment_collection_form_examples"

module Decidim
  module Admin
    describe AttachmentCollectionForm do
      include_examples "attachment collection form" do
        let(:participatory_space) do
          create :participatory_process, organization: organization
        end
      end
    end
  end
end
