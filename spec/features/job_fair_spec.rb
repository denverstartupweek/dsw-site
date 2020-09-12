require "spec_helper"

feature "Filling out the job fair form" do
  before do
    ENV["JOB_FAIR_SIGNUP_EMAIL_RECIPIENTS"] = "jobfair@example.com"
  end

  scenario "User submits a signup when already logged in" do
    visit "/"
    click_on "Sign Up / Sign In"
    fill_in "Name", with: "New Guy"
    fill_in "E-mail Address", with: "test@example.com"
    fill_in "Password", with: "password", match: :prefer_exact
    fill_in "Confirm Password", with: "password", match: :prefer_exact
    click_on "Submit"

    visit "/get-involved"
    find(".ContentCard", text: "HIRE GREAT TALENT").click_link("Learn more")

    fill_in "Company or Organization", with: "Acme Corp"
    select "Energy", from: "Industry Category"
    select "1-50 employees", from: "Organization Size"
    fill_in "Secondary Contact E-mail (optional)", with: "test2@example.com"
    select "Yes", from: "Are you actively hiring?"
    fill_in "How many positions are you currently hiring for?", with: "10"
    fill_in "How many positions do you anticipate filling in the next 12 months?", with: "20"

    fill_in "How has COVID-19 impacted your hiring plans?", with: "Somewhat"
    fill_in "Any additional notes?", with: "Nope"
    click_button "Submit"
    expect(page).to have_text("Thanks! We will be in touch shortly.")

    # Saved to DB
    expect(JobFairSignup.count).to eq(1)
    last_signup = JobFairSignup.last
    expect(last_signup.user.name).to eq("New Guy")
    expect(last_signup.user.email).to eq("test@example.com")
    expect(last_signup.company.name).to eq("Acme Corp")
    expect(last_signup.industry_category).to eq("Energy")
    expect(last_signup.organization_size).to eq("1-50 employees")
    expect(last_signup.covid_impact).to eq("Somewhat")
    expect(last_signup.notes).to eq("Nope")
    expect(last_signup.number_open_positions).to eq(10)
    expect(last_signup.number_hiring_next_12_months).to eq(20)
    expect(last_signup.year).to eq(Date.today.year)

    # Confirmation to e-mail box
    expect(last_email_sent).to have_subject("Someone has signed up to exhibit at the DSW Job Fair")
    expect(last_email_sent).to deliver_to("jobfair@example.com")
    expect(last_email_sent).to reply_to("test@example.com")
    expect(last_email_sent).to cc_to("test2@example.com", "test@example.com")
  end

  scenario "User submits a signup when already logged in" do
    # click_on "Sign Up / Sign In"

    visit "/get-involved"
    find(".ContentCard", text: "HIRE GREAT TALENT").click_link("Learn more")

    fill_in "Name", with: "New Guy"
    fill_in "E-mail Address", with: "test@example.com"
    fill_in "Password", with: "password", match: :prefer_exact
    fill_in "Confirm Password", with: "password", match: :prefer_exact
    click_on "Submit"

    find(".ContentCard", text: "HIRE GREAT TALENT").click_link("Learn more")

    fill_in "Company or Organization", with: "Acme Corp"
    select "Energy", from: "Industry Category"
    select "1-50 employees", from: "Organization Size"
    fill_in "Secondary Contact E-mail (optional)", with: "test2@example.com"
    select "Yes", from: "Are you actively hiring?"
    fill_in "How many positions are you currently hiring for?", with: "10"
    fill_in "How many positions do you anticipate filling in the next 12 months?", with: "20"

    fill_in "How has COVID-19 impacted your hiring plans?", with: "Somewhat"
    fill_in "Any additional notes?", with: "Nope"
    click_button "Submit"
    expect(page).to have_text("Thanks! We will be in touch shortly.")

    # Saved to DB
    expect(JobFairSignup.count).to eq(1)
    last_signup = JobFairSignup.last
    expect(last_signup.user.name).to eq("New Guy")
    expect(last_signup.user.email).to eq("test@example.com")
    expect(last_signup.company.name).to eq("Acme Corp")
    expect(last_signup.industry_category).to eq("Energy")
    expect(last_signup.organization_size).to eq("1-50 employees")
    expect(last_signup.covid_impact).to eq("Somewhat")
    expect(last_signup.notes).to eq("Nope")
    expect(last_signup.number_open_positions).to eq(10)
    expect(last_signup.number_hiring_next_12_months).to eq(20)
    expect(last_signup.year).to eq(Date.today.year)

    # Confirmation to e-mail box
    expect(last_email_sent).to have_subject("Someone has signed up to exhibit at the DSW Job Fair")
    expect(last_email_sent).to deliver_to("jobfair@example.com")
    expect(last_email_sent).to reply_to("test@example.com")
    expect(last_email_sent).to cc_to("test2@example.com", "test@example.com")
  end

  xscenario "User submits a signup but fails to include all fields" do
    visit "/"
    click_on "Sign Up / Sign In"
    fill_in "Name", with: "New Guy"
    fill_in "E-mail Address", with: "test@example.com"
    fill_in "Password", with: "password", match: :prefer_exact
    fill_in "Confirm Password", with: "password", match: :prefer_exact
    click_on "Submit"

    visit "/get-involved"
    find(".ContentCard", text: "HIRE GREAT TALENT").click_link("Learn more")

    fill_in "Company or Organization", with: "Acme Corp"
    click_button "Submit"

    expect(page).not_to have_text("Thanks! We will be in touch shortly.")
    expect(page).to have_content("We were unable to process your response. Please correct it and try again.")

    expect(JobFairSignup.count).to eq(0)
  end

  describe "Editing a signup when it's been approved" do
    let(:user) do
      create(:user, email: "test@example.com", password: "password")
    end

    let(:company) { create(:company, name: "ExampleCo") }

    scenario "a user who does not have an approved job fair signup for the current year should not see anything in the dashboard" do
      create(:job_fair_signup, user: user, state: "accepted", year: 2019, company: company)
      create(:job_fair_signup, user: user, state: "rejected", year: 2020, company: company)
      travel_to Date.parse("2020-04-01") do
        login_as user, scope: :user
        visit "/dashboard"
        expect(page).to have_no_content("JOB FAIR - EXAMPLECO")
      end
    end

    scenario "a user with an approved job fair signup for the current year can edit it from the dashboard" do
      create(:job_fair_signup,
        user: user,
        state: "accepted",
        year: 2020,
        company: company)
      create(:submission,
        start_day: 2,
        start_hour: 12,
        end_day: 2,
        end_hour: 13,
        state: "confirmed",
        is_virtual_job_fair_slot: true)
      travel_to Date.parse("2020-04-01") do
        login_as user, scope: :user
        visit "/dashboard"
        click_on "Edit Registration"
        check "Monday 12:00pm — 1:00pm"
        click_button "Submit"
        expect(page).to have_content("Your changes have been saved")
        click_on "Edit Registration"
        expect(find("tr", text: "Monday")).to have_checked_field("Monday 12:00pm — 1:00pm")
      end
    end

    xscenario "a user who has venues assigned should be able to edit their details and availability" do
      login_as venue_host_user, scope: :user
      create(:venue, company: company, name: "Example Theatre").tap do |v|
        v.admins << venue_host_user
      end

      visit "/dashboard"
      find(".VenueCard", text: "EXAMPLE THEATRE").click_link("Edit")
      fill_in "Venue Name", with: "Test Theatre"
      fill_in "Availability preference", with: "No special preference"
      find("tr", text: "Tuesday").check "12 - 2pm"
      find("tr", text: "Thursday").check "2 - 4pm"
      find("tr", text: "Thursday").check "4 - 6pm"
      find("tr", text: "Friday").check "6 - 10pm"
      click_button "Submit"
      expect(page).to have_content("Venue was successfully updated")
      find(".VenueCard", text: "TEST THEATRE").click_link("Edit")
      expect(find("tr", text: "Tuesday")).to have_checked_field("12 - 2pm")
      expect(find("tr", text: "Thursday")).to have_checked_field("2 - 4pm")
      expect(find("tr", text: "Thursday")).to have_checked_field("4 - 6pm")
      expect(find("tr", text: "Friday")).to have_checked_field("6 - 10pm")
      expect(page).to have_content("No special preference")
    end
  end
end
