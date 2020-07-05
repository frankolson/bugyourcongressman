module CongressOfficialsHelper
  def chamber_type_options
    [
      [t('.chamber_options.both'),'Both'],
      [t('.chamber_options.house'),'House'],
      [t('.chamber_options.senate'),'Senate']
    ]
  end

  def official_photo_url(official)
    official.photo_url.present? ?
      official.photo_url :
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
  end

  def titles(official)
    titles = official.offices.collect do |office|
      office.name + " #{t('.for')} " + office.division.name
    end

    safe_join titles, raw('<br />')
  end

  def channel_link_to(channel)
    case channel.type
    when 'Facebook'
      link_to "https://facebook.com/#{channel.id}" do
        tag.i(class: 'fab fa-facebook') + ' Facebook'
      end
    when 'Twitter'
      link_to "https://twitter.com/#{channel.id}" do
        tag.i(class: 'fab fa-twitter') + ' Twitter'
      end
    end
  end

  def phone_link_to(phone_number)
    link_to "tel:#{phone_number}" do
      tag.i(class: 'fas fa-phone') + " #{phone_number}"
    end
  end

  def email_link_to(email, index)
    link_to "mailto:#{email}" do
      tag.i(class: 'fas fa-envelope') +
        " #{t('.email')} #{titled_count(index)}"
    end
  end

  def website_link_to(website, index)
    link_to website do
      tag.i(class: 'fas fa-globe') +
        " #{t('.website')} #{titled_count(index)}"
    end
  end

  private

    def titled_count(count)
      count == 0 ? nil : count + 1
    end
end
