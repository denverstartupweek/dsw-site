require "spec_helper"

feature "Voting for session submissions" do
  let(:user) do
    create(:user, email: "test@example.com", password: "password")
  end

  let(:track) do
    create(:track, name: "Founder", is_submittable: true)
  end

  let!(:submission) do
    create(:submission,
      submitter: user,
      title: "I am a session",
      description: "interesting stuff",
      track: track,
      contact_email: "test@example.com",
      state: "open_for_voting",
      coc_acknowledgement: true,
      year: AnnualSchedule.current.year)
  end

  describe "when voting is open" do
    before do
      travel_to AnnualSchedule.current.voting_open_at.to_datetime + 2.days
    end

    after do
      travel_back
    end

    scenario "User votes for a session when already signed in" do
      login_as user, scope: :user
      visit "/voting"
      expect(page).to have_content("I AM A SESSION")

      click_link "Vote for 'I am a session'"
      expect(page).to have_css(".SessionCard-vote-count", text: "1 VOTE")

      # Clicking twice should have no effect
      click_link "Vote for 'I am a session'"
      expect(page).to have_css(".SessionCard-vote-count", text: "1 VOTE")
    end

    scenario "User votes for a session after being prompted to sign in" do
      visit "/voting"
      expect(page).to have_content("I AM A SESSION")

      click_link "Vote for 'I am a session'"
      fill_in "E-mail Address", with: "test@example.com"
      fill_in "Password", with: "password", match: :prefer_exact
      click_button "Submit"
      click_link "Vote for 'I am a session'"
      expect(page).to have_css(".SessionCard-vote-count", text: "1 VOTE")

      # Clicking twice should have no effect
      click_link "Vote for 'I am a session'"
      expect(page).to have_css(".SessionCard-vote-count", text: "1 VOTE")
    end

    scenario "User votes for a session from the session detail page" do
      login_as user, scope: :user
      visit "/voting"
      expect(page).to have_content("I AM A SESSION")
      visit find(".SessionCard", text: "I AM A SESSION").find(".SessionCard-link")["href"]
      click_link "Vote for this session (0 so far)"
      expect(page).to have_css(".SubmissionDetail-vote-text", text: "1 vote")

      # Clicking twice should have no effect
      click_link "Vote for this session"
      expect(page).to have_css(".SubmissionDetail-vote-text", text: "1 vote")
    end
  end

  describe "when voting is closed" do
    before do
      travel_to AnnualSchedule.current.voting_close_at.to_datetime + 2.days
    end

    after do
      travel_back
    end

    scenario "User tries to access voting when voting is closed" do
      visit "/voting"
      expect(page).to have_content("Feedback for #{Date.today.year} is currently closed")
      expect(current_path).to eq("/voting/feedback_closed")
    end
  end
end
