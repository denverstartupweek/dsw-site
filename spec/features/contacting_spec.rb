require "spec_helper"

feature "Filling out the contact form" do
  before do
    ENV["VOLUNTEER_SIGNUP_EMAIL_RECIPIENTS"] = "volunteer@example.com"
  end

  scenario "User submits a contact request" do
    visit "/"
    click_link "Contact Us"
    fill_in "Name", with: "Some person"
    fill_in "Company or Organization (optional)", with: "Acme Corp"
    fill_in "E-mail Address", with: "test@example.com"
    select "Sponsorship", from: "What are you interested in?"
    fill_in "Any additional notes?", with: "Nope"
    click_button "Submit"
    expect(page).to have_text("Thanks! We will be in touch shortly.")

    # Saved to DB
    expect(GeneralInquiry.count).to eq(1)
    expect(GeneralInquiry.last.contact_email).to eq("test@example.com")
    expect(GeneralInquiry.last.contact_name).to eq("Some person")
    expect(GeneralInquiry.last.company).to eq("Acme Corp")
    expect(GeneralInquiry.last.interest).to eq("sponsorship")
    expect(GeneralInquiry.last.notes).to eq("Nope")

    # Confirmation to volunteers box
    expect(last_email_sent).to have_subject("Someone has inquired about DSW")
    expect(last_email_sent).to deliver_to("volunteer@example.com")
    expect(last_email_sent).to reply_to("test@example.com")
  end

  scenario "User submits a contact request but fails the captcha check" do
    allow(Recaptcha).to receive(:skip_env?).and_return(false)
    visit "/"
    click_link "Contact Us"
    fill_in "Name", with: "Some person"
    fill_in "Company or Organization (optional)", with: "Acme Corp"
    fill_in "E-mail Address", with: "test@example.com"
    select "Sponsorship", from: "What are you interested in?"
    fill_in "Any additional notes?", with: "Nope"
    click_button "Submit"

    expect(page).to have_content("reCAPTCHA verification failed, please try again.")
  end
end
