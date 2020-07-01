require 'test_helper'

class MockOfficer
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

  test "should post select_chamber" do
    post switchboards_select_chamber_url(Digits: '55555')

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.select_chamber.create.chamber_prompt')
  end

  test "should post select_congressman with results" do
    CivicInformation::RepresentativesResource.stubs(:where).
      returns(stub(officers: [MockRepresentative.new]))

    post switchboards_select_congressman_url(Digits: '1', select_congressman: { zipcode: '55555' })

    assert_response :success
    assert_select 'Say', count: 1, text: I18n.t(
        'switchboards.select_congressman.create.prompt',
        digit: 1,
        name: 'Jacky Rosen'
      )
  end

  test "should post select_congressman with no results" do
    CivicInformation::RepresentativesResource.stubs(:where).
      returns(stub(officers: []))

    post switchboards_select_congressman_url(Digits: '1', select_congressman: { zipcode: '55555' })

    assert_response :success
    assert_select 'Say', count: 0
    assert_select 'Redirect', switchboards_invalid_zipcode_path
  end

  test "should post dial" do
    CivicInformation::RepresentativesResource.stubs(:where).
      returns(stub(officers: [MockRepresentative.new]))

    post switchboards_dial_url(Digits: '1', dial: { zipcode: '55555', chamber: '1' })

    assert_response :success
    assert_select 'Say', I18n.t(
        'switchboards.dial.create.instructions',
        name: 'Jacky Rosen'
      )
    # FIXME: A hack because the assertions could not find xml elements if they after others. Wierd.
    assert_match /Dial>202-224-6244/, @response.body
  end

  test "should post invalid_zipcode" do
    post switchboards_invalid_zipcode_url

    assert_response :success
    assert_select 'Say', I18n.t('switchboards.invalid_zipcode.create.description')
  end
end
