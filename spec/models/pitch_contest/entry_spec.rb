require "rails_helper"

RSpec.describe PitchContest::Entry, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:video_url) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  it { is_expected.to allow_value("youtu.be/EK7J_ZzvF8k").for(:video_url) }
  it { is_expected.to allow_value("http://youtu.be/EK7J_ZzvF8k").for(:video_url) }
  it { is_expected.to allow_value("https://youtu.be/EK7J_ZzvF8k").for(:video_url) }
  it { is_expected.to allow_value("https://vimeo.com/176248673").for(:video_url) }
  it { is_expected.to allow_value("http://vimeo.com/176248673").for(:video_url) }
  it { is_expected.not_to allow_value("youtube.com/watch?v=EK7J_ZzvF8k").for(:video_url) }
  it { is_expected.not_to allow_value("youtube.com/watch").for(:video_url) }

  describe "transforming video URLs into embed URLs" do
    it "transforms a Youtube URL without a scheme" do
      expect(PitchContest::Entry.new(video_url: "youtu.be/EK7J_ZzvF8k").embed_video_url)
        .to eq("https://www.youtube.com/embed/EK7J_ZzvF8k?modestbranding=1&showinfo=0")
    end

    it "transforms a Youtube URL with a scheme" do
      expect(PitchContest::Entry.new(video_url: "http://youtu.be/EK7J_ZzvF8k").embed_video_url)
        .to eq("https://www.youtube.com/embed/EK7J_ZzvF8k?modestbranding=1&showinfo=0")
    end

    it "transforms an HTTPS Youtube URL" do
      expect(PitchContest::Entry.new(video_url: "https://youtu.be/EK7J_ZzvF8k").embed_video_url)
        .to eq("https://www.youtube.com/embed/EK7J_ZzvF8k?modestbranding=1&showinfo=0")
    end

    it "transforms an HTTPS Vimeo URL" do
      expect(PitchContest::Entry.new(video_url: "https://vimeo.com/176248673").embed_video_url)
        .to eq("https://player.vimeo.com/video/176248673")
    end
  end
end
