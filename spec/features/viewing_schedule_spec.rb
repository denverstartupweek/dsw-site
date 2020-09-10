require "spec_helper"

feature "Viewing the schedule" do
  let(:submitter) do
    create(:user, email: "test@example.com",
                  password: "password")
  end

  let(:track) do
    create(:track, name: "Founder",
                   is_submittable: true)
  end

  let!(:submission) do
    create(:submission,
      submitter: submitter,
      title: "I am a session",
      description: "interesting stuff",
      track: track,
      contact_email: "test@example.com",
      state: "confirmed",
      start_day: 2,
      start_hour: 10,
      end_day: 2,
      end_hour: 11.5,
      year: AnnualSchedule.current.registration_open_at.year)
  end

  let!(:previous_submission) do
    create(:submission,
      submitter: submitter,
      title: "I am an older session",
      description: "interesting stuff",
      track: track,
      contact_email: "test@example.com",
      state: "confirmed",
      start_day: 2,
      start_hour: 10,
      end_day: 2,
      end_hour: 11.5,
      year: AnnualSchedule.current.registration_open_at.year - 1)
  end

  describe "in the current year/registration cycle" do
    before do
      travel_to AnnualSchedule.current.registration_open_at.to_datetime + 1.day
    end

    after do
      travel_back
    end

    scenario "Registering to attend from the schedule page" do
      visit "/schedule"
      expect(current_path).to eq("/schedule/2017/monday")
      expect(page).to have_content("I am a session")
      select(1.year.ago.year.to_s, from: "year")
      expect(current_path).to eq("/schedule/2016/monday")
      expect(page).to have_content("I am an older session")
    end
  end

  describe "viewing a personal schedule when registered" do
    scenario "I should be able to subscribe from my dashboard" do
      pending("refactor")
      select "View My Schedule", from: "filter"
      ical = URI.open(find(:link, "Add to Outlook/iCal")[:href].gsub("webcal://", "http://"))
      calendars = Icalendar.parse(ical)
      expect(calendars.first.events.size).to eq(1)
      expect(calendars.first.events.first.summary).to eq("I am a session")
    end
  end
end
