xml.instruct!

xml.Gather(num_digits: '1', action: switchboards_enter_zipcode_path, timeout: 5,
  actionOnEmptyResult: true) do

  alice_says(builder: xml, message: t('.intro'))
  alice_says(builder: xml, message: t('.language_prompt'), language: 'es-MX')
end