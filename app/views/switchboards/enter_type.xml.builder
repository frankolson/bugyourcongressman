xml.instruct!

xml.Gather(num_digits: '5', timeout: 20,
  action: switchboards_representatives_path(representatives: { zipcode: @user_zipcode })) do

  alice_says(builder: xml, message: t('.type_prompt'))
end