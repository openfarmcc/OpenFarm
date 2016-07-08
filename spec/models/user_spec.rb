require 'spec_helper'

describe User do
  it 'Should create a valid user' do
    user = FactoryGirl.create(:confirmed_user)
    expect(user).to be_valid
  end

  it 'Should not create a valid user if missing required info' do
    expect(FactoryGirl.build(:confirmed_user, email: nil)).to_not be_valid
    expect(FactoryGirl.build(:confirmed_user, display_name: nil)).to_not be_valid
  end

  it 'should be valid to have both location and units in user_setting' do
    user = FactoryGirl.create(:user, :with_user_setting)
    expect(user.has_filled_required_settings?).to be true
  end

  context "should be invalid to not fill in required settings" do
    it 'should be invalid to have either of location or units missing' do
      user = FactoryGirl.create(:user)
      expect(user.has_filled_required_settings?).to be false
    end
  end

  it 'should connect to mailchimp if mailing list and confirmed' do
    stub_request(:post, "https://api.mailchimp.com/2.0/lists/list")
      .to_return(:body => '{"total":1,"data":[{"id":"7ec999ba49","web_id":540717,"name":"OpenFarm Helpers","date_created":"2015-04-03 08:25:15","email_type_option":false,"use_awesomebar":true,"default_from_name":"The OpenFarm Team","default_from_email":"kevin@openfarm.cc","default_subject":"","default_language":"en","list_rating":0,"subscribe_url_short":"http:\/\/eepurl.com\/biTabv","subscribe_url_long":"http:\/\/openfarm.us8.list-manage.com\/subscribe?u=&id=7ec999ba49","beamer_address":"us8@inbound.mailchimp.com","visibility":"pub","stats":{"member_count":24,"unsubscribe_count":0,"cleaned_count":0,"member_count_since_send":27,"unsubscribe_count_since_send":0,"cleaned_count_since_send":0,"campaign_count":0,"grouping_count":0,"group_count":0,"merge_var_count":1,"avg_sub_rate":0,"avg_unsub_rate":0,"target_sub_rate":0,"open_rate":0,"click_rate":0,"date_last_campaign":null},"modules":[]}],"errors":[]}')
    stub_request(:post, "https://us8.api.mailchimp.com/2.0/lists/list")
      .to_return(:body => '{"total":1,"data":[{"id":"7ec999ba49","web_id":540717,"name":"OpenFarm Helpers","date_created":"2015-04-03 08:25:15","email_type_option":false,"use_awesomebar":true,"default_from_name":"The OpenFarm Team","default_from_email":"kevin@openfarm.cc","default_subject":"","default_language":"en","list_rating":0,"subscribe_url_short":"http:\/\/eepurl.com\/biTabv","subscribe_url_long":"http:\/\/openfarm.us8.list-manage.com\/subscribe?u=&id=7ec999ba49","beamer_address":"us8@inbound.mailchimp.com","visibility":"pub","stats":{"member_count":24,"unsubscribe_count":0,"cleaned_count":0,"member_count_since_send":27,"unsubscribe_count_since_send":0,"cleaned_count_since_send":0,"campaign_count":0,"grouping_count":0,"group_count":0,"merge_var_count":1,"avg_sub_rate":0,"avg_unsub_rate":0,"target_sub_rate":0,"open_rate":0,"click_rate":0,"date_last_campaign":null},"modules":[]}],"errors":[]}')
    stub_request(:post, "https://api.mailchimp.com/2.0/lists/subscribe")
      .to_return(:body => '{"apikey":"","id":"7ec999ba49","email":{"email":"blanca.lehner@klockodoyle.net"},"merge_vars":{"DNAME":"Alek Romaguera"},"double_optin":false,"update_existing":true}')
    stub_request(:post, "https://us8.api.mailchimp.com/2.0/lists/subscribe")
      .to_return(:body => '{"apikey":"","id":"7ec999ba49","email":{"email":"blanca.lehner@klockodoyle.net"},"merge_vars":{"DNAME":"Alek Romaguera"},"double_optin":false,"update_existing":true}')
    user = FactoryGirl.create(:confirmed_user)
    user.mailing_list = true
    user.save
  end

  it 'should connect to mailchimp if help list and confirmed' do
    # These tests are pretty meaningless with the VCR, but we also don't
    # want to add fake sign-ups every time tests are run.
    stub_request(:post, "https://api.mailchimp.com/2.0/lists/list")
      .to_return(:body => '{"total":1,"data":[{"id":"7ec999ba49","web_id":540717,"name":"OpenFarm Helpers","date_created":"2015-04-03 08:25:15","email_type_option":false,"use_awesomebar":true,"default_from_name":"The OpenFarm Team","default_from_email":"kevin@openfarm.cc","default_subject":"","default_language":"en","list_rating":0,"subscribe_url_short":"http:\/\/eepurl.com\/biTabv","subscribe_url_long":"http:\/\/openfarm.us8.list-manage.com\/subscribe?u=&id=7ec999ba49","beamer_address":"us8@inbound.mailchimp.com","visibility":"pub","stats":{"member_count":24,"unsubscribe_count":0,"cleaned_count":0,"member_count_since_send":27,"unsubscribe_count_since_send":0,"cleaned_count_since_send":0,"campaign_count":0,"grouping_count":0,"group_count":0,"merge_var_count":1,"avg_sub_rate":0,"avg_unsub_rate":0,"target_sub_rate":0,"open_rate":0,"click_rate":0,"date_last_campaign":null},"modules":[]}],"errors":[]}')
    stub_request(:post, "https://us8.api.mailchimp.com/2.0/lists/list")
      .to_return(:body => '{"total":1,"data":[{"id":"7ec999ba49","web_id":540717,"name":"OpenFarm Helpers","date_created":"2015-04-03 08:25:15","email_type_option":false,"use_awesomebar":true,"default_from_name":"The OpenFarm Team","default_from_email":"kevin@openfarm.cc","default_subject":"","default_language":"en","list_rating":0,"subscribe_url_short":"http:\/\/eepurl.com\/biTabv","subscribe_url_long":"http:\/\/openfarm.us8.list-manage.com\/subscribe?u=&id=7ec999ba49","beamer_address":"us8@inbound.mailchimp.com","visibility":"pub","stats":{"member_count":24,"unsubscribe_count":0,"cleaned_count":0,"member_count_since_send":27,"unsubscribe_count_since_send":0,"cleaned_count_since_send":0,"campaign_count":0,"grouping_count":0,"group_count":0,"merge_var_count":1,"avg_sub_rate":0,"avg_unsub_rate":0,"target_sub_rate":0,"open_rate":0,"click_rate":0,"date_last_campaign":null},"modules":[]}],"errors":[]}')
    stub_request(:post, "https://api.mailchimp.com/2.0/lists/subscribe")
      .to_return(:body => '{"apikey":"","id":"7ec999ba49","email":{"email":"blanca.lehner@klockodoyle.net"},"merge_vars":{"DNAME":"Alek Romaguera"},"double_optin":false,"update_existing":true}')
    stub_request(:post, "https://us8.api.mailchimp.com/2.0/lists/subscribe")
      .to_return(:body => '{"apikey":"","id":"7ec999ba49","email":{"email":"blanca.lehner@klockodoyle.net"},"merge_vars":{"DNAME":"Alek Romaguera"},"double_optin":false,"update_existing":true}')
    user = FactoryGirl.create(:confirmed_user)
    user.help_list = true
    user.save
  end
end
