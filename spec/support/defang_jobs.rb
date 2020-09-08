RSpec.configure do |config|
  config.before(:each) do
    allow(ListSubscriptionJob).to receive(:perform_async)
    allow(CreateOrUpdateVideoIntegrationsJob).to receive(:perform_async)
  end
end
