require "rails_helper"

RSpec.describe Company, type: :model do
  describe "validations" do
    subject { build(:company) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  it { is_expected.to have_many(:registrations).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:submissions).dependent(:restrict_with_error) }

  describe "combining multiple companies together" do
    let!(:company1) { create(:company) }
    let!(:registration1) { create(:registration, company: company1) }
    let!(:submission1) { create(:submission, company: company1) }
    let!(:venue1) { create(:venue, company: company1) }
    let!(:company2) { create(:company) }
    let!(:registration2) { create(:registration, company: company2) }
    let!(:submission2) { create(:submission, company: company2) }
    let!(:venue2) { create(:venue, company: company2) }
    let!(:company3) { create(:company) }
    let!(:registration3) { create(:registration, company: company3) }
    let!(:submission3) { create(:submission, company: company3) }
    let!(:venue3) { create(:venue, company: company3) }

    before do
      Company.combine!(company1, company2, company3)
    end

    it "combines registrations" do
      expect(registration1.reload.company).to eq(company1)
      expect(registration2.reload.company).to eq(company1)
      expect(registration3.reload.company).to eq(company1)
    end

    it "combines submissions" do
      expect(submission1.reload.company).to eq(company1)
      expect(submission2.reload.company).to eq(company1)
      expect(submission3.reload.company).to eq(company1)
    end

    it "combines venues" do
      expect(venue1.reload.company).to eq(company1)
      expect(venue2.reload.company).to eq(company1)
      expect(venue3.reload.company).to eq(company1)
    end

    it "removes duplicated company records" do
      expect { company2.reload }.to raise_exception(ActiveRecord::RecordNotFound)
      expect { company3.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
