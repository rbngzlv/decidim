# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Admin
    describe ManagedUserForm, with_authorization_workflows: ["dummy_authorization_handler"] do
      subject do
        described_class.from_params(
          name: name
        ).with_context(
          current_organization: organization
        )
      end

      let(:organization) { create :organization }
      let(:name) { "Foo" }

      context "when everything is OK" do
        it { is_expected.to be_valid }
      end

      context "when the name is not present" do
        let(:name) { nil }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
