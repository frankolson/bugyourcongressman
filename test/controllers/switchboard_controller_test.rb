require 'test_helper'

class MockRepresentative
  def name
    'Jacky Rosen'
  end

  def phones
    ['202-224-6244']
  end
end

class SwitchboardControllerTest < ActionDispatch::IntegrationTest
  test "should post welcome" do
    post switchboards_welcome_url

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.welcome.create.intro')
    assert_select 'Say', I18n.t('switchboards.welcome.create.language_prompt')
  end

  test "should post enter_zipcode" do
    post switchboards_enter_zipcode_url(Digits: '1')

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.enter_zipcode.create.zipcode_prompt')
  end

  test "should post enter_chamber" do
    post switchboards_enter_chamber_url(Digits: '55555')

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.enter_chamber.create.chamber_prompt')
  end

  test "should post representatives with results" do
    CivicInformation::Representative.stubs(:where).
      returns([MockRepresentative.new])

    post switchboards_representatives_url(Digits: '1', representatives: { zipcode: '55555' })

    assert_response :success
    assert_select 'Say', count: 1, text: I18n.t(
        'switchboards.representatives.create.prompt',
        digit: 1,
        name: 'Jacky Rosen'
      )
  end

  test "should post representatives with no results" do
    CivicInformation::Representative.stubs(:where).returns([])

    post switchboards_representatives_url(Digits: '1', representatives: { zipcode: '55555' })

    assert_response :success
    assert_select 'Say', count: 0
    assert_select 'Redirect', switchboards_no_zipcode_path
  end

  test "should post dial" do
    CivicInformation::Representative.stubs(:where).
      returns([MockRepresentative.new])

    post switchboards_dial_url(Digits: '1', dial: { zipcode: '55555', chamber: '1' })

    assert_response :success
    assert_select 'Say', I18n.t(
        'switchboards.dial.create.instructions',
        name: 'Jacky Rosen'
      )
    # FIXME: A hack because the assertions could not find xml elements if they after others. Wierd.
    assert_match /Dial>202-224-6244/, @response.body
  end

  test "should post no_zipcode" do
    post switchboards_no_zipcode_url

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.no_zipcode.create.description')
  end
end
