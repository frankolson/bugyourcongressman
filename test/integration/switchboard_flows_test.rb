require 'test_helper'

class MockRepresentative
  def name
    'Jacky Rosen'
  end

  def phones
    ['202-224-6244']
  end
end

class SwitchboardFlowsTest < ActionDispatch::IntegrationTest
  test 'happy path' do
    CivicInformation::Representative.stubs(:where).
      returns([MockRepresentative.new])
    user_zipcode = '55555'

    # Greeted
    post switchboards_welcome_url
    assert_response :success

    # redirected to enter zipcode
    assert_select 'Gather', attributes: { action: switchboards_enter_zipcode_url }
    post switchboards_enter_zipcode_url(Digits: 1)
    assert_response :success

    # redirected to representatives
    assert_select 'Gather', attributes: { action: switchboards_representatives_path }
    post switchboards_representatives_path(zipcode: user_zipcode) # Twilio will call this
    assert_response :success

    # given representative options
    assert_select 'Say', count: 1, text: I18n.t(
      'switchboards.representatives.prompt',
      digit: 1,
      name: 'Jacky Rosen'
    )

    # redirected to dial
    assert_select 'Gather', attributes: {
        action: switchboards_dial_path(zipcode: user_zipcode)
      }
    post switchboards_dial_path(zipcode: user_zipcode) # Twilio will call this
    assert_response :success

    # dial congressman
    assert_select 'Dial', '202-224-6244'
    assert_select 'Hangup'
  end

  test 'properly handeling Spanish locale' do
    CivicInformation::Representative.stubs(:where).
      returns([MockRepresentative.new])
    user_zipcode = '55555'

    # Greeted
    post switchboards_welcome_url
    assert_response :success

    # redirected to enter zipcode
    post switchboards_enter_zipcode_path(Digits: 2)
    assert_response :success
    assert_equal :es, I18n.locale

    # redirected to representatives
    post switchboards_representatives_path(zipcode: user_zipcode) # Twilio will call this
    assert_response :success
    assert_equal :es, I18n.locale

    # redirected to dial
    post switchboards_dial_path(zipcode: user_zipcode) # Twilio will call this
    assert_response :success
    assert_equal :es, I18n.locale
  end

  test 'zipcode does not match any representatives' do
    CivicInformation::Representative.stubs(:where).returns([])
    user_zipcode = '55555'

    # Greeted
    post switchboards_welcome_url
    assert_response :success

    # redirected to representatives
    assert_select 'Gather', attributes: { action: switchboards_representatives_path }
    post switchboards_representatives_path(zipcode: user_zipcode) # Twilio will call this
    assert_response :success

    # redirected to no zipcode path
    assert_select 'Redirect', switchboards_no_zipcode_path
    post switchboards_no_zipcode_path

    # dial main congress switchboard
    assert_select 'Dial', '2022243121'
    assert_select 'Hangup'
  end
end