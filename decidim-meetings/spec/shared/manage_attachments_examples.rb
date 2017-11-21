# frozen_string_literal: true

require "spec_helper"

shared_examples "manage meetings attachments" do
  let(:attached_to) { meeting }

  before do
    within find("tr", text: translated(meeting.title)) do
      find("a.action-icon--attachments").click
    end
  end

  it_behaves_like "manage attachments examples"
end
