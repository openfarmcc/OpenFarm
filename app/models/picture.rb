class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :photographic, inverse_of: :pictures, polymorphic: true

  has_mongoid_attached_file :attachment,
    styles: { small:  ['100x100#', :jpg],
              medium: ['250x250',  :jpg],
              large:  ['500x500>', :jpg] },
    :convert_options => { all: '-background transparent -flatten +matte' }
  validates_attachment_size :attachment, in: 1.byte..2.megabytes
  validates_attachment :attachment,
                       content_type: { content_type:
                         ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] }

  def self.from_url(url, parent)
    pic = create(photographic: parent)
    pic.add_image(url)
    pic
  end

  # Delayed_job is unable to work on non-persisted records, so we're forced
  # to wrap the update_attributes method and handle it asynchronously
  def add_image(url)
    update_attributes(attachment: open(url))
  end
  handle_asynchronously :add_image
end
