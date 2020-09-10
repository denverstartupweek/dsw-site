require "spec_helper"

feature "Managing My Venue" do
  let(:user) do
    create(:user, email: "test@example.com", password: "password")
  end

  let(:company) { create(:company, name: "ExampleCo") }

  let(:venue_host_user) do
    create(:user, email: "test@example.com", password: "password").tap do |u|
      u.companies << company
    end
  end

  scenario "a user who does not have any venues assigned should not see anything in the list" do
    login_as user, scope: :user
    visit "/dashboard"
    expect(page).not_to have_content("MY VENUES")
  end

  scenario "a user who has venues assigned should be able to edit their details and availability" do
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

  scenario "a user should see venues with availability that has been taken as non-editable" do
    login_as venue_host_user, scope: :user
    create(:venue, company: company, name: "Example Theatre").tap do |v|
      v.admins << venue_host_user
    end

    visit "/dashboard"
    find(".VenueCard", text: "EXAMPLE THEATRE").click_link("Edit")
    fill_in "Venue Name", with: "Test Theatre"
    find("tr", text: "Tuesday").check "12 - 2pm"
    click_button "Submit"
    expect(page).to have_content("Venue was successfully updated")
    VenueAvailability.first.assign! create(:submission)

    find(".VenueCard", text: "TEST THEATRE").click_link("Edit")
    expect(find("tr", text: "Tuesday")).to have_checked_field("12 - 2pm", disabled: true)
  end
end
