xml.instruct!

xml.Response do
  if @congressmen.any?
    xml.Gather(num_digits: '1', timeout: 20,
      action: switchboards_dial_path(zipcode: @user_zipcode, role_type: @selected_role)) do

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