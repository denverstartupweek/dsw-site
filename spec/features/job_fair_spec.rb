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

  scenario "User submits a signup but fails the captcha check" do
    allow(Recaptcha).to receive(:skip_env?).and_return(false)
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

    expect(page).not_to have_text("Thanks! We will be in touch shortly.")
    expect(page).to have_content("reCAPTCHA verification failed, please try again.")

    expect(JobFairSignup.count).to eq(0)
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
end
