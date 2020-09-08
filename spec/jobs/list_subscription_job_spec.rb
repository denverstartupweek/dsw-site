require "spec_helper"

# !!! HERE BE DRAGONS !!!
# This is a bad set of tests, but I'm at a loss for better ways to
# handle this kind of deeply-nested stubbing. I don't think they
# provide a lot of value, however.

describe ListSubscriptionJob, job: true, vcr: true do
  before do
    allow(ListSubscriptionJob).to receive(:perform_async).and_call_original
    ENV["SENDGRID_LIST_ID"] = "abc123"
  end

  before do
    # Stub the contact upsert to return success
    response = instance_double("SendGrid::Response",
      body: '{ "persisted_recipients": [ 1 ] }',
      status_code: 201)
    allow_any_instance_of(SendGrid::API).to receive_message_chain(:client,
      :contactdb,
      :recipients,
      :patch).with(
        request_body: [
          {
            email: "test@example.com",
            first_name: "Test",
            last_name: "User"
          }
        ]
      ) do
      response
    end
  end

  describe "with no additional fields supplied" do
    it "subscribes an email to the general list" do
      lists_double = double
      allow_any_instance_of(SendGrid::API).to receive_message_chain(:client,
        :contactdb,
        :lists).and_return(lists_double)
      list_double = double
      expect(lists_double).to receive(:_).with("abc123").and_return(list_double)
      expect(list_double).to receive_message_chain(:recipients,
        :_,
        :post) do
        instance_double("SendGrid::Response", status_code: 201)
      end

      ListSubscriptionJob.perform_async("test@example.com",
        first_name: "Test",
        last_name: "User")
    end
  end

  describe "with confirmed_years supplied" do
    describe "when a confirmed list for the specified year exists" do
      it "subscribes the user to two lists" do
        lists_double = double
        allow_any_instance_of(SendGrid::API).to receive_message_chain(:client,
          :contactdb,
          :lists).and_return(lists_double)
        # Lists get request
        response = instance_double("SendGrid::Response",
          status_code: 200,
          body: {
            lists: [{
              id: 25,
              name: "DSW Presenters 2018",
              recipient_count: 1
            }]
          }.to_json)
        expect(lists_double).to receive(:get).and_return(response)

        # List subscription requests - receive_message_chain doesn't allow `twice` so here we are
        response_created = instance_double("SendGrid::Response", status_code: 201)
        list_double1 = double
        expect(list_double1).to receive_message_chain(:recipients,
          :_,
          :post).and_return(response_created)
        expect(lists_double).to receive(:_).with("abc123").and_return(list_double1)
        list_double2 = double
        expect(list_double2).to receive_message_chain(:recipients,
          :_,
          :post).and_return(response_created)
        expect(lists_double).to receive(:_).with(25).and_return(list_double2)
        ListSubscriptionJob.perform_async("test@example.com",
          first_name: "Test",
          last_name: "User",
          confirmed_years: [2018])
      end
    end
    describe "when a confirmed list for the specified year does not exist"
  end

  describe "with submitted_years supplied" do
    describe "when a submitted list for the specified year exists" do
      it "subscribes the user to two lists" do
        lists_double = double
        allow_any_instance_of(SendGrid::API).to receive_message_chain(:client,
          :contactdb,
          :lists).and_return(lists_double)
        # Lists get request
        response = instance_double("SendGrid::Response",
          status_code: 200,
          body: {
            lists: [{
              id: 25,
              name: "DSW Submitters 2018",
              recipient_count: 1
            }]
          }.to_json)
        expect(lists_double).to receive(:get).and_return(response)

        # List subscription requests - receive_message_chain doesn't allow `twice` so here we are
        response_created = instance_double("SendGrid::Response", status_code: 201)
        list_double1 = double
        expect(list_double1).to receive_message_chain(:recipients,
          :_,
          :post).and_return(response_created)
        expect(lists_double).to receive(:_).with("abc123").and_return(list_double1)
        list_double2 = double
        expect(list_double2).to receive_message_chain(:recipients,
          :_,
          :post).and_return(response_created)
        expect(lists_double).to receive(:_).with(25).and_return(list_double2)
        ListSubscriptionJob.perform_async("test@example.com",
          first_name: "Test",
          last_name: "User",
          submitted_years: [2018])
      end
    end

    describe "when a confirmed list for the specified year does not exist" do
      it "creates a new list and subscribes the user to two lists"
    end
  end
end
