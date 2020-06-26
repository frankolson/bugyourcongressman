xml.instruct!

xml.Response do
  xml.Gather(numDigits: '5', timeout: 20, action: switchboards_enter_chamber_path) do
    alice_says(builder: xml, message: t('.zipcode_prompt'))
  end
end