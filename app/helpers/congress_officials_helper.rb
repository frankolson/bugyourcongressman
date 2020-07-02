module CongressOfficialsHelper
  def official_photo_url(official)
    official.photo_url.present? ?
      official.photo_url :
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
  end

  def channel_link_to(channel)
    case channel.type
    when 'Facebook'
      link_to('Facebook', "https://facebook.com/#{channel.id}")
    when 'Twitter'
      link_to('Twitter', "https://twitter.com/#{channel.id}")
    end
  end
end
