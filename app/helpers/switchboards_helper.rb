module SwitchboardsHelper
  def alice_says(builder:, message:, language: nil)
    builder.Say(
      message,
      voice: 'alice',
      language: language || t('twilio_language')
    )
  end
end
