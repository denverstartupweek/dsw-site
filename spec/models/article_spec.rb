require "rails_helper"

RSpec.describe Article, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(150) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to have_many(:authors) }
  it { is_expected.to have_many(:authorships).dependent(:destroy) }
  it { is_expected.to have_and_belong_to_many(:tracks) }
  it { is_expected.to belong_to(:submitter) }

  describe "finding related articles" do
    let(:submitter) { create(:user) }
    let(:author) { create(:user) }
    let(:company) { create(:company) }
    let(:track) { create(:track) }
    let(:article) do
      create(:article,
        submitter: submitter,
        tracks: [track],
        company: company,
        authors: [author])
    end
    let(:publishing) { create(:publishing, subject: article, effective_at: 1.day.ago) }

    it "returns nothing if no other articles exist" do
      expect(publishing.subject.related).to be_empty
    end

    describe "when articles from the same submitter exist" do
      let!(:other_article) { create(:article, submitter: submitter) }
      let!(:other_publishing) { create(:publishing, subject: other_article, effective_at: 1.day.ago) }

      it "returns articles from the same submitter" do
        expect(publishing.subject.related).to include(other_article)
      end
    end

    describe "when articles from the same company exist" do
      let!(:other_article) { create(:article, company: company) }
      let!(:other_publishing) { create(:publishing, subject: other_article, effective_at: 1.day.ago) }

      it "returns articles from the same company" do
        expect(publishing.subject.related).to include(other_article)
      end
    end

    describe "when articles from the same tracks exist" do
      let(:other_track) { create(:track) }
      let!(:other_article) { create(:article, tracks: [track, other_track]) }
      let!(:other_publishing) { create(:publishing, subject: other_article, effective_at: 1.day.ago) }

      it "returns articles from the same track" do
        expect(publishing.subject.related).to include(other_article)
      end
    end

    describe "when articles from the same authors exist" do
      let(:other_author) { create(:user) }
      let!(:other_article) { create(:article, authors: [author, other_author]) }
      let!(:other_publishing) { create(:publishing, subject: other_article, effective_at: 1.day.ago) }

      it "returns articles from the same author" do
        expect(publishing.subject.related).to include(other_article)
      end
    end
  end
end
