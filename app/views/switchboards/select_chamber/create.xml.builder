xml.instruct!

xml.Response do
  xml.Gather(numDigits: '1', timeout: 20,
    action: switchboards_select_congressman_path(select_congressman: { zipcode: @user_zipcode })) do

    alice_says(builder: xml, message: t('.chamber_prompt'))
  end
end