xml.instruct!

xml.Response do
  xml.Gather(numDigits: '1', timeout: 20,
    action: switchboards_representatives_path(representatives: { zipcode: @user_zipcode })) do

    alice_says(builder: xml, message: t('.chamber_prompt'))
  end
end