require "spec_helper"

describe SendAttendeeMessageJob, job: true do
  let(:msg) do
    create(:attendee_message, subject: "Important", body: "Please read me")
  end

  let(:registration) { create(:registration) }

  it "sends a message" do
    msg.submission.user_registrations << registration
    SendAttendeeMessageJob.new.perform(msg.id)
    expect(last_email_sent).to deliver_to("Denver Startup Week <info@denverstartupweek.org>")
    expect(last_email_sent).to have_subject("Regarding '#{msg.submission.full_title}': Important")
    expect(last_email_sent).to have_body_text(/Please read me/)
    expect(last_email_sent).to have_header("X-SMTPAPI", "{\"to\": [\"#{registration.user.email}\"]}")
  end
end
