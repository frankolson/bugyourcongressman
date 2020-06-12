xml.instruct!

xml.Gather(num_digits: '5', action: switchboards_representatives_path,
  timeout: 20) do

  alice_says(builder: xml, message: t('.zipcode_prompt'))
end