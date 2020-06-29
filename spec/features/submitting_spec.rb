require "spec_helper"

feature "Creating a submission" do
  before do
    @chair = create(:user, name: "Mr. Chairman", email: "chair@example.com", password: "passsword")
    @track = create(:track, name: "Bizness", is_submittable: true, chair_ids: [@chair.id])
  end

  describe "when submissions are open" do
    let!(:company) { create(:company, name: "Example.com") }

    before do
      travel_to AnnualSchedule.current.cfp_open_at.to_datetime + 1.day
    end

    after do
      travel_back
    end

    scenario "User submits a new idea" do
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact

      click_on "Submit"
      visit "/dashboard" # More straightforward than waiting for the flash to disappear

      click_on "Submit New Proposal"
      select "Bizness", from: "submission_track_id"
      select "10 minutes", from: "submission_preferred_length"
      select "Workshop", from: "submission_format"
      fill_in "submission_title", with: "Some talk"
      fill_in "submission_description", with: "I am going to give a talk."
      fill_in "submission_target_audience_description", with: "People who like talks."
      fill_in "submission_notes", with: "Please pick my talk."
      fill_in "submission_contact_email", with: "test2@example.com"
      fill_in "submission_proposal_video_url", with: "https://www.youtube.com/watch?v=Us6jaZoXgdU&t=26s"
      check "submission_coc_acknowledgement"
      check "submission_dei_acknowledgement"

      # Use the autocompleter to select
      fill_in "submission_company_name", with: "Exa"
      find(".awesomplete li", text: "Example.com").click

      click_button "Submit"
      expect(page).to have_content("Thanks!")

      # See it in the list
      expect(page).to have_css(".SessionCard", text: "SOME TALK")
      expect(page).to have_css(".SessionCard", text: "BIZNESS")
      expect(page).to have_css(".SessionCard", text: "I am going to give a talk.")

      # Confirmation to track chair
      email = ActionMailer::Base.deliveries.detect { |e| e.to.include?("chair@example.com") }
      expect(email.subject).to eq("A new DSW submission has been received for the Bizness track")

      # Confirmation to submitter
      email = ActionMailer::Base.deliveries.detect { |e| e.to.include?("test2@example.com") }
      expect(email.subject).to eq("Thanks for submitting a session proposal for Denver Startup Week!")
    end

    scenario "User submits a new idea but fails to include required fields" do
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact

      click_on "Submit"
      visit "/dashboard" # More straightforward than waiting for the flash to disappear

      click_on "Submit New Proposal"
      select "Bizness", from: "submission_track_id"
      fill_in "submission_title", with: "Some talk"
      check "submission_coc_acknowledgement"
      check "submission_dei_acknowledgement"
      click_button "Submit"

      expect(page).not_to have_content("Thanks!")
      expect(page).to have_content("Please correct the following errors:")

      expect(Submission.count).to eq(0)
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    scenario "User tries to submit a new idea but fails to create an account" do
      create(:user, name: "Here First", email: "test@example.com", password: "password")
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact
      click_on "Submit"
      expect(page).to have_content("Email has already been taken")
    end

    scenario "User edits an existing submission" do
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact

      click_on "Submit"
      visit "/dashboard" # More straightforward than waiting for the flash to disappear

      click_on "Submit New Proposal"
      select "Bizness", from: "submission_track_id"
      fill_in "submission_title", with: "Some talk"
      fill_in "submission_description", with: "I am going to give a talk."
      fill_in "submission_notes", with: "Please pick my talk."
      fill_in "submission_target_audience_description", with: "People who like talks."
      fill_in "submission_contact_email", with: "test2@example.com"
      check "submission_coc_acknowledgement"
      check "submission_dei_acknowledgement"
      click_button "Submit"

      click_on "Propose Updates"
      fill_in "submission_title", with: "Updated talk"
      fill_in "submission_description", with: "Here is my udpated idea"
      fill_in "submission_notes", with: "I have even more things to say now."
      click_button "Submit"

      expect(page).to have_css(".SessionCard", text: "SOME TALK")
      expect(page).to have_content "Thanks! Your changes have been submitted and are pending review."

      submission = Submission.last
      submission.promote_updates!
      visit page.current_path

      expect(page).to have_css(".SessionCard", text: "UPDATED TALK")
      expect(page).not_to have_css(".SessionCard", text: "SOME TALK")
      expect(last_email_sent).to deliver_to("test@example.com", "test2@example.com")
      expect(last_email_sent).to have_subject "Your proposed session updates have been accepted"
      expect(submission.sent_notifications.last.kind).to eq(SentNotification::UPDATES_ACCEPTED_KIND)
    end
  end

  describe "when submissions are closed" do
    before do
      travel_to AnnualSchedule.current.cfp_close_at.to_datetime + 2.days
    end

    after do
      travel_back
    end

    scenario "User tries to submit a new idea when the CFP is closed" do
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact

      click_on "Submit"

      visit "/dashboard"

      expect(page).to have_no_link("Submit New Proposal")

      visit "/voting/submit"

      expect(page).to have_content("Session submissions for #{Date.today.year} are currently closed")
      expect(current_path).to eq("/dashboard")
    end

    scenario "User tries to submit a new idea when they have a CFP extension in place" do
      visit "/"
      click_on "Sign Up / Sign In"
      fill_in "Name", with: "New Guy"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      fill_in "Confirm Password", with: "password", match: :prefer_exact

      click_on "Submit"

      User.last.create_cfp_extension!(expires_at: 3.days.from_now)

      visit "/dashboard"

      expect(page).to have_link("Submit New Proposal")
    end
  end
end
