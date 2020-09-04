require "rails_helper"

RSpec.describe OauthService, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to allow_values(*OauthService::PROVIDERS).for(:provider) }

  describe "creating & updating from omniauth hashes" do
    let(:current_user) { create(:user) }

    describe "via Zoom" do
      let(:omniauth_hash) do
        {
          "provider" => "zoom",
          "uid" => "66RIPutABCDqBNI5VQA9Tw",
          "info" => {
            "id" => "66RIPutABCDqBNI5VQA9Tw",
            "first_name" => "Nikhil",
            "last_name" => "Gupta",
            "email" => "nick@yourdomain.com",
            "type" => 1,
            "pmi" => 123123123,
            "use_pmi" => false,
            "personal_meeting_url" => "https://zoom.us/j/123123123",
            "timezone" => "",
            "verified" => 0,
            "dept" => "",
            "created_at" => "2018-08-20T08:43:44Z",
            "last_login_time" => "2018-09-07T07:51:47Z",
            "last_client_version" => "4.1.28165.0716(mac)",
            "pic_url" => "https://lh4.googleusercontent.com/-ncv-QFDfBKA/AAAAAAAAAAI/AAAAAAAAAA0/jOGyW7vaMus/photo.jpg?sz=50",
            "host_key" => "123456",
            "group_ids" => [],
            "im_group_ids" => [],
            "account_id" => "CrH_wNzoRBACBhMaCggL4A"
          },
          "credentials" => {
            "token" => "TOKEN",
            "refresh_token" => "REFRESH_TOKEN",
            "expires_at" => 1496120719,
            "expires" => true
          },
          "extra" => {
            "scope" => ""
          }
        }
      end

      describe "when no record exists" do
        it "creates a new record with the appropriate fields" do
          described_class.find_or_create_from_auth_hash(omniauth_hash, current_user)
          expect(current_user.oauth_services.count).to eq(1)
          svc = current_user.oauth_services.first
          expect(svc.uid).to eq("66RIPutABCDqBNI5VQA9Tw")
          expect(svc.provider).to eq("zoom")
          expect(svc.token).to eq("TOKEN")
          expect(svc.refresh_token).to eq("REFRESH_TOKEN")
          expect(svc.token_expires_at).to eq(DateTime.parse("2017-05-30 05:05:19.000000000 +0000"))
        end
      end

      describe "when a record exists already" do
        let!(:service) do
          current_user.oauth_services.create!(uid: "66RIPutABCDqBNI5VQA9Tw", provider: "zoom")
        end

        it "updates the existing record with the appropriate fields" do
          described_class.find_or_create_from_auth_hash(omniauth_hash, current_user)
          expect(current_user.oauth_services.count).to eq(1)
          svc = current_user.oauth_services.first
          expect(svc.uid).to eq("66RIPutABCDqBNI5VQA9Tw")
          expect(svc.provider).to eq("zoom")
          expect(svc.token).to eq("TOKEN")
          expect(svc.refresh_token).to eq("REFRESH_TOKEN")
          expect(svc.token_expires_at).to eq(DateTime.parse("2017-05-30 05:05:19.000000000 +0000"))
        end
      end
    end

    describe "via Youtube (Google)" do
      let(:omniauth_hash) do
        {
          "provider" => "youtube",
          "uid" => "100000000000000000000",
          "info" => {
            "name" => "John Smith",
            "email" => "john@example.com",
            "first_name" => "John",
            "last_name" => "Smith",
            "image" => "https://lh4.googleusercontent.com/photo.jpg",
            "urls" => {
              "google" => "https://plus.google.com/+JohnSmith"
            }
          },
          "credentials" => {
            "token" => "TOKEN",
            "refresh_token" => "REFRESH_TOKEN",
            "expires_at" => 1496120719,
            "expires" => true
          },
          "extra" => {
            "id_token" => "ID_TOKEN",
            "id_info" => {
              "azp" => "APP_ID",
              "aud" => "APP_ID",
              "sub" => "100000000000000000000",
              "email" => "john@example.com",
              "email_verified" => true,
              "at_hash" => "HK6E_P6Dh8Y93mRNtsDB1Q",
              "iss" => "accounts.google.com",
              "iat" => 1496117119,
              "exp" => 1496120719
            },
            "raw_info" => {
              "sub" => "100000000000000000000",
              "name" => "John Smith",
              "given_name" => "John",
              "family_name" => "Smith",
              "profile" => "https://plus.google.com/+JohnSmith",
              "picture" => "https://lh4.googleusercontent.com/photo.jpg?sz=50",
              "email" => "john@example.com",
              "email_verified" => "true",
              "locale" => "en",
              "hd" => "company.com"
            }
          }
        }
      end

      describe "when no record exists" do
        it "creates a new record with the appropriate fields" do
          described_class.find_or_create_from_auth_hash(omniauth_hash, current_user)
          expect(current_user.oauth_services.count).to eq(1)
          svc = current_user.oauth_services.first
          expect(svc.uid).to eq("100000000000000000000")
          expect(svc.provider).to eq("youtube")
          expect(svc.token).to eq("TOKEN")
          expect(svc.refresh_token).to eq("REFRESH_TOKEN")
          expect(svc.token_expires_at).to eq(DateTime.parse("2017-05-30 05:05:19.000000000 +0000"))
        end
      end

      describe "when a record exists already" do
        let!(:service) do
          current_user.oauth_services.create!(uid: "100000000000000000000", provider: "youtube")
        end

        it "updates the existing record with the appropriate fields" do
          described_class.find_or_create_from_auth_hash(omniauth_hash, current_user)
          expect(current_user.oauth_services.count).to eq(1)
          svc = current_user.oauth_services.first
          expect(svc.uid).to eq("100000000000000000000")
          expect(svc.provider).to eq("youtube")
          expect(svc.token).to eq("TOKEN")
          expect(svc.refresh_token).to eq("REFRESH_TOKEN")
          expect(svc.token_expires_at).to eq(DateTime.parse("2017-05-30 05:05:19.000000000 +0000"))
        end
      end
    end
  end
end
