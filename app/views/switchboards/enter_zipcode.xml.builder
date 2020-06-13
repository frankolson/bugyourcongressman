xml.instruct!

xml.Gather(num_digits: '5', timeout: 20, action: switchboards_enter_chamber_path) do
  alice_says(builder: xml, message: t('.zipcode_prompt'))
end