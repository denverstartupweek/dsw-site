require "spec_helper"

describe VenueAvailability, type: :model do
  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_presence_of(:day) }
  it { is_expected.to validate_presence_of(:time_block) }
  it { is_expected.to validate_uniqueness_of(:submission_id) }
  it { is_expected.to belong_to(:submission).optional }
  it { is_expected.to belong_to(:venue) }

  describe "assigning/unassigning submissions" do
    let(:submission) { create(:submission) }
    let(:venue) { create(:venue) }
    let(:venue_availability) { venue.venue_availabilities.create(year: 2019, day: 2, time_block: 1) }

    describe "when assigning" do
      it "updates the local relationships and the submission venue" do
        expect(venue_availability.assign!(submission)).to be_truthy
        expect(venue_availability.submission).to eq(submission)
        expect(submission.venue).to eq(venue)
      end

      it "fails when an availability is already assigned to another submission" do
        other_submission = create(:submission)
        expect(venue_availability.assign!(other_submission)).to be_truthy
        expect(venue_availability.assign!(submission)).to be_falsy
        expect(venue_availability.submission).to eq(other_submission)
        expect(submission.venue).to be_nil
        expect(other_submission.venue).to eq(venue)
      end
    end

    describe "when unassigning" do
      it "updates the local relationships and the submission venue" do
        expect(venue_availability.assign!(submission)).to be_truthy
        expect(venue_availability.unassign!).to be_truthy
        expect(venue_availability.submission).to be_nil
        expect(submission.venue).to be_nil
      end
    end
  end
end
