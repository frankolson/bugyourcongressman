xml.instruct!

xml.Response do
  if @congressmen.any?
    xml.Gather(numDigits: '1', timeout: 20,
      action: switchboards_dial_path(dial: { zipcode: @user_zipcode, chamber: @chamber })) do

      @congressmen.each_with_index do |congressman, index|
        alice_says(
          builder: xml,
          message: t('.prompt', digit: index + 1, name: congressman.name),
        )
      end
    end
  else
    xml.Redirect(switchboards_no_zipcode_path)
  end
end