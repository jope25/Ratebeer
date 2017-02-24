class Place < OpenStruct
  def self.rendered_fields
    [:status, :city, :overall ]
  end

  def address_line
    ERB::Util.url_encode("#{name} #{street} #{zip} #{city}")
  end

  def url
    "//www.google.com/maps/embed/v1/place?q=#{address_line}&zoom=17&key=#{ENV['GOOGLE_APIKEY']}"
  end
end