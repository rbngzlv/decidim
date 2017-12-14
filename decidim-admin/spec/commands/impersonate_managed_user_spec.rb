# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe ImpersonateManagedUser do
    include ActiveSupport::Testing::TimeHelpers

    subject { described_class.new(handler, user, current_user) }

    let(:organization) { create :organization }
    let(:current_user) { create :user, :admin, organization: organization }
    let(:document_number) { "12345678X" }
    let(:user) { create :user, :managed, organization: organization }
    let(:handler_document_number) { document_number }
    let(:handler) do
      Decidim::DummyAuthorizationHandler.from_params(
        document_number: handler_document_number,
        user: user
      )
    end

    context "when everything is ok" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates a impersonation log" do
        expect do
          subject.call
        end.to change { Decidim::ImpersonationLog.count }.by(1)
      end

      it "expires the impersonation session automatically" do
        perform_enqueued_jobs { subject.call }
        travel Decidim::ImpersonationLog::SESSION_TIME_IN_MINUTES.minutes
        expect(Decidim::ImpersonationLog.last).to be_expired
      end
    end

    context "when the user is not managed" do
      let(:user) { create :user }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the authorization is not valid" do
      let(:handler_document_number) { "12345678Y" }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end
