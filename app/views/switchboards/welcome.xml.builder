xml.instruct!

xml.Response do
  xml.Gather(numDigits: '1', action: switchboards_enter_zipcode_path, timeout: 5,
    actionOnEmptyResult: true) do

    alice_says(builder: xml, message: t('.intro'))
    alice_says(builder: xml, message: t('.language_prompt'), language: 'es-MX')
  end
end