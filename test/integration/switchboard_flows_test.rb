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
    # byebug
    # assert_select 'Gather[action=?]', switchboards_enter_zipcode_path
    post switchboards_enter_zipcode_url(Digits: 1)
    assert_response :success

    # redirected to enter_chamber
    # assert_select 'Gather[action=?]', switchboards_enter_chamber_path
    post switchboards_enter_chamber_path(Digits: 1) # Twilio will call this
    assert_response :success

    # redirected to representatives
    # assert_select 'Gather[action=?]',
    #   switchboards_representatives_path(representatives: { zipcode: user_zipcode })
    post switchboards_representatives_path(representatives: { zipcode: user_zipcode }) # Twilio will call this
    assert_response :success

    # given representative options
    assert_select 'Say', count: 1, text: I18n.t(
      'switchboards.representatives.prompt',
      digit: 1,
      name: 'Jacky Rosen'
    )

    # redirected to dial
    assert_select 'Gather', attributes: {
        action: switchboards_dial_path(dial: { zipcode: user_zipcode, chamber: '1' })
      }
    post switchboards_dial_path(dial: { zipcode: user_zipcode, chamber: '1' }) # Twilio will call this
    assert_response :success

    # dial congressman
    # FIXME: A hack because the assertions could not find xml elements if they after others. Wierd.
    assert_match /Dial>202-224-6244/, @response.body
    assert_match /Hangup/, @response.body
  end

  test 'properly handeling Spanish locale' do
    CivicInformation::Representative.stubs(:where).
      returns([MockRepresentative.new])
    user_zipcode = '55555'

    # Greeted
    post switchboards_welcome_url
    assert_response :success
    assert_select 'Say[language=?]', 'en-US', count: 1
    assert_select 'Say[language=?]', 'es-MX', count: 1

    # redirected to enter zipcode
    post switchboards_enter_zipcode_path(Digits: 2)
    assert_response :success
    assert_equal :es, I18n.locale
    assert_select 'Say[language=?]', 'es-MX', count: 1

    # redirected to representatives
    post switchboards_representatives_path(representatives: { zipcode: user_zipcode }) # Twilio will call this
    assert_response :success
    assert_equal :es, I18n.locale
    assert_select 'Say[language=?]', 'es-MX', count: 1


    # redirected to dial
    post switchboards_dial_path(dial: { zipcode: user_zipcode, chamber: '1' }) # Twilio will call this
    assert_response :success
    assert_equal :es, I18n.locale
    assert_select 'Say[language=?]', 'es-MX', count: 1
  end

  test 'zipcode does not match any representatives' do
    CivicInformation::Representative.stubs(:where).returns([])
    user_zipcode = '55555'

    # Greeted
    post switchboards_welcome_url
    assert_response :success

    # redirected to representatives
    assert_select 'Gather', attributes: { action: switchboards_representatives_path }
    post switchboards_representatives_path(representatives: { zipcode: user_zipcode }) # Twilio will call this
    assert_response :success

    # redirected to no zipcode path
    assert_select 'Redirect', switchboards_no_zipcode_path
    post switchboards_no_zipcode_path

    # dial main congress switchboard
    # FIXME: A hack because the assertions could not find xml elements if they after others. Wierd.
    assert_match /Dial>2022243121/, @response.body
    assert_match /Hangup/, @response.body
  end
end