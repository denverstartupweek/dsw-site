require "rails_helper"

RSpec.describe Publishing, type: :model do
  it { is_expected.to validate_presence_of(:effective_at) }
  it { is_expected.to belong_to(:subject) }

  describe "filtering results" do
    let!(:article) { create(:article, title: "Hello", body: "world") }
    let!(:article_publishing) { create(:publishing, subject: article) }
    let!(:submission) { create(:submission, title: "Talk", description: "Tech") }
    let!(:submission_publishing) { create(:publishing, subject: submission) }

    it "allows a search with no criteria, returning all results" do
      results = Publishing.filtered_results({})
      expect(results.count).to eq(2)
    end

    it "allows a search on article title" do
      results = Publishing.filtered_results(terms: "hello")
      expect(results.count).to eq(1)
      expect(results.first.subject).to eq(article)
    end

    it "allows a search on article body" do
      results = Publishing.filtered_results(terms: "world")
      expect(results.count).to eq(1)
      expect(results.first.subject).to eq(article)
    end

    it "allows a search on article author" do
      article.authors << create(:user, name: "John Doe")
      results = Publishing.filtered_results(terms: "Doe")
      expect(results.count).to eq(1)
      expect(results.first.subject).to eq(article)
    end

    it "allows a search on session title" do
      results = Publishing.filtered_results(terms: "talk")
      expect(results.count).to eq(1)
      expect(results.first.subject).to eq(submission)
    end

    it "allows a search on session description" do
      results = Publishing.filtered_results(terms: "tech")
      expect(results.count).to eq(1)
      expect(results.first.subject).to eq(submission)
    end
  end
end
