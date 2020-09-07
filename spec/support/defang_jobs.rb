RSpec.configure do |config|
  config.before(:each, type: :model) do
    allow(CreateOrUpdateYoutubeLiveJob).to receive(:perform_async)
  end
end
