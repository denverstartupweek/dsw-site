require "spec_helper"

feature "Editing my profile" do
  xit "Editing an account from the edit profile page" do
    visit "/dashboard"
    fill_in "First and Last Name", with: "Test Registrant"
    fill_in "E-mail Address", with: "test2@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    click_button "Submit"
    click_link "Edit Profile"
    attach_file("user_avatar",
      Rails.root.join("spec", "support", "avatar_examples", "more_than_2_mb.jpg"),
      make_visible: true)
    page.driver.browser.switch_to.alert.accept
    attach_file("user_avatar",
      Rails.root.join("spec", "support", "avatar_examples", "less_than_2_mb.png"),
      make_visible: true)
    fill_in "First and Last Name", with: "Test Registrant 2"
    fill_in "user_current_password", with: "password"
    choose "user_show_attendance_publicly_false", visible: false
    click_button "Update"
    expect(page).to have_css(".Dashboard-profile-name", text: "Test Registrant 2")
    expect(page).to have_css('.Avatar-image[src$="less_than_2_mb.png"]')
    expect(User.find_by(email: "test2@example.com").show_attendance_publicly?).to be_falsy
  end
end
